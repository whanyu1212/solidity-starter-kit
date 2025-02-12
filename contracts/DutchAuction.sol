// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IModifiedERC20.sol";
import "./IMyNFT.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/**
 * @title DutchAuction
 * @dev This contract demonstrates a Dutch auction for NFTs.
 * @author hy
 * @notice Date: 12/02/2025
 */
contract DutchAuction is IERC721Receiver {
    //--------------------------------------------------------------------------------
    // State Variables
    //--------------------------------------------------------------------------------

    IModifiedERC20 public token;
    IMyNFT public nft;
    // Using a constant for the number of seconds in a day
    uint256 private constant SECONDS_PER_DAY = 86400;
    // Using a constant for the daily reduction percentage
    uint256 private constant DAILY_REDUCTION_PERCENTAGE = 90;

    struct Auction {
        address seller;
        uint256 startPrice;
        uint256 endPrice;
        uint256 duration;
        uint256 startTime;
        bool active;
    }

    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------

    // The constructor should register a token address and an NFT address
    constructor(address _token, address _nft) {
        token = IModifiedERC20(_token);
        nft = IMyNFT(_nft);
    }

    // Mapping from NFT token ID to its auction details
    mapping(uint256 => Auction) public auctions;

    //--------------------------------------------------------------------------------
    // Events
    //--------------------------------------------------------------------------------
    event AuctionRegistered(
        address indexed seller,
        uint256 indexed tokenId,
        uint256 startPrice,
        uint256 endPrice,
        uint256 duration,
        uint256 startTime
    );

    event AuctionCancelled(uint256 indexed tokenId, address indexed seller);
    event AuctionSuccessful(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );

    //--------------------------------------------------------------------------------
    // Functions

    /**
     * @notice This function registers an auction for the specified NFT.
     * @param _tokenId The ID of the NFT to be auctioned.
     * @param _startPrice The starting price of the auction.
     * @param _endPrice The ending price of the auction.
     */
    function registerAuction(
        uint256 _tokenId,
        uint256 _startPrice,
        uint256 _endPrice,
        uint256 _duration
    ) public {
        // Check the person registering the auction is the owner of that specific NFT
        require(nft.ownerOf(_tokenId) == msg.sender, "Not owner of NFT");

        // Ensure no active auction is already registered for this token
        require(
            !auctions[_tokenId].active,
            "Auction already active for this token"
        );

        // Validate parameters: duration must be positive and startPrice must be greater than endPrice
        require(_duration > 0, "Duration must be > 0");
        require(_startPrice > 0, "Start price must be > 0");
        require(_endPrice > 0, "End price must be > 0");
        require(_startPrice > _endPrice, "Start price must be > end price");

        // Transfer the NFT to this contract.
        // NOTE: The NFT owner must have approved this contract before calling registerAuction.
        nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        // Register the auction details
        auctions[_tokenId] = Auction({
            seller: msg.sender,
            startPrice: _startPrice,
            endPrice: _endPrice,
            duration: _duration,
            startTime: block.timestamp,
            active: true // boolean flag to indicate the auction is active
        });

        // Emit an event for off-chain tracking
        emit AuctionRegistered(
            msg.sender,
            _tokenId,
            _startPrice,
            _endPrice,
            _duration,
            block.timestamp
        );
    }

    // Safety check: verifies that this contract can receive ERC721 tokens
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /**
     * @notice This function cancels an active auction.
     * @param _tokenId The ID of the NFT for which the auction is to be cancelled.
     */
    function cancelAuction(uint256 _tokenId) public {
        Auction storage auction = auctions[_tokenId];

        // Check that the auction is active
        require(auction.active, "Auction not active");

        // Check that the caller is the seller
        require(auction.seller == msg.sender, "Not auction seller");

        // Transfer the NFT back to the seller
        nft.safeTransferFrom(address(this), msg.sender, _tokenId);

        // Mark the auction as inactive
        auction.active = false;

        emit AuctionCancelled(_tokenId, msg.sender);
    }

    /**
     * @notice This function calculates the current price of the NFT.
     * @param _tokenId The ID of the NFT for which the price is to be calculated.
     * @return The current price of the NFT.
     */

    function getPrice(uint256 _tokenId) public view returns (uint256) {
        Auction storage auction = auctions[_tokenId];

        // Check that the auction is active
        require(auction.active, "Auction not active");

        // The price drops 10% every day
        uint256 daysElapsed = (block.timestamp - auction.startTime) /
            SECONDS_PER_DAY;

        // Using the formula: price = startPrice * (0.9 ^ daysElapsed)
        uint256 reduction = 10 ** 18; // Start with 1 in 18 decimal precision
        for (uint256 i = 0; i < daysElapsed; i++) {
            reduction = (reduction * DAILY_REDUCTION_PERCENTAGE) / 100; // Multiply by 0.9 each day
        }

        uint256 currentPrice = (auction.startPrice * reduction) / (10 ** 18);

        // Ensure price doesn't go below end price
        return
            currentPrice > auction.endPrice ? currentPrice : auction.endPrice;
    }

    /**
     * @notice This function allows a buyer to purchase an NFT.
     * @param _tokenId The ID of the NFT to be purchased.
     */
    function buy(uint256 _tokenId) public {
        Auction storage auction = auctions[_tokenId];

        // Check that the auction is active
        require(auction.active, "Auction not active");

        // Calculate the current price
        uint256 price = getPrice(_tokenId);

        // Check if buyer has approved enough tokens
        require(
            token.allowance(msg.sender, address(this)) >= price,
            "Insufficient token allowance"
        );

        // Transfer the tokens from the buyer to the seller
        token.transferFrom(msg.sender, auction.seller, price);

        // Transfer the NFT from this contract to the buyer
        nft.safeTransferFrom(address(this), msg.sender, _tokenId);

        // Mark the auction as inactive
        auction.active = false;

        emit AuctionSuccessful(_tokenId, auction.seller, msg.sender, price);
    }
}
