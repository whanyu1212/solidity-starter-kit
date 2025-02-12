// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// In Solidity, all code must be inside a contract because it is a contract-oriented programming language.
// A contract is the fundamental building block of Ethereum applications.

/**
 * @title Lab1
 * @dev This contract demonstrates the use of state variables and functions in Solidity.
 * @author hy
 * @notice Date: 07/02/2025
 */
contract Lab1 {
    // These state variables are stored permanently in the blockchain.
    uint256 public price;
    uint256[] quantities;

    /**
     *@notice This function sets the price of the product.
     *@param val The price of the product.
     */
    function setPrice(uint256 val) public {
        price = val;
    }

    /**
     *@notice This function sets the quantities of the products.
     *@param arr An array of quantities.
     */
    function setQuantities(uint256[] memory arr) public {
        // you can use memory, storage, calldata to specify the location of the variable
        quantities = arr;
    }

    /**
     *@notice This function calculates the total price of the products.
     *@return The total price of the products.
     */
    function totalPrice() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < quantities.length; i++) {
            total += quantities[i] * price;
        }
        return total;
    }
}
