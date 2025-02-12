// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing the ERC721 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title MyNFT
 * @dev This contract demonstrates the creation of an NFT using the ERC721 standard.
 * @author hy
 * @notice Date: 08/02/2025
 */
contract MyNFT is ERC721 {
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {}

    /**
     * @notice This function mints a new NFT and assigns it to the specified address.
     * @param to The address to which the NFT will be assigned.
     * @param id The ID of the NFT.
     */
    function mint(address to, uint256 id) external {
        _mint(to, id);
    }
    // we make use of the internal function in ERC721 to get the owner of the token
    //     contract ERC721 {
    //     // Internal mapping from token ID to owner address
    //     mapping(uint256 => address) private _owners;

    //     // Internal function that inheriting contracts can use
    //     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
    //         return _owners[tokenId];
    //     }
    // }
    /**
     * @notice This function burns the NFT with the specified ID.
     * @param id The ID of the NFT to be burned.
     */
    function burn(uint256 id) external {
        require(msg.sender == _ownerOf(id), "not owner");
        _burn(id);
    }
}
