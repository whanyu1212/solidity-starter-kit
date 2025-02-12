// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title TokenSwap
 * @dev This contract demonstrates a simple token swap between two parties.
 * @author hy
 * @notice Date: 08/02/2025
 */
contract TokenSwap {
    // The interface of IERC is available because we imported the ERC20.sol file

    // --------------------------------------------------
    // State Variables
    // --------------------------------------------------
    IERC20 public token1;
    address public owner1;
    uint256 public amount1;
    IERC20 public token2;
    address public owner2;
    uint256 public amount2;

    // --------------------------------------------------
    // Constructor
    // --------------------------------------------------
    constructor(
        address _token1,
        address _owner1,
        uint256 _amount1,
        address _token2,
        address _owner2,
        uint256 _amount2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
        amount2 = _amount2;
    }

    /**
     * @notice This function allows the owners to swap tokens.
     */
    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            // allowance reads current spending limit
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );
        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    /**
     * @notice This function transfers tokens from one address to another.
     * @param token The token to be transferred.
     * @param sender The address from which the tokens will be transferred.
     * @param recipient The address to which the tokens will be transferred.
     * @param amount The amount of tokens to be transferred.
     */
    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
