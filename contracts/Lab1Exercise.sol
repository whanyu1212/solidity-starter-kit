// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// In Solidity, all code must be inside a contract
contract Lab1Exercise {
    /**
     * @title Lab1Exercise
     * @dev This contract demonstrates the use of state variables and functions in Solidity.
     * @author hy
     * @notice Date: 07/02/2025
     */
    struct item {
        string name;
        uint256 price;
        uint256 quantity;
        bool isSoldOut;
    }

    item[] public items;

    /**
     *@notice This function adds a new item to the items array.
     *@param newItem The new item to be added.
     */
    function addItem(item memory newItem) public {
        items.push(newItem);
    }

    /**
     *@notice This function sets the isSoldOut flag to true for the item at the specified index.
     *@param index The index of the item to be marked as sold out.
     */
    function soldOut(uint256 index) public {
        items[index].isSoldOut = true;
    }

    /**
     *@notice This function returns the number of items in the items array.
     *@return The number of items in the items array.
     */

    function numberOfItems() public view returns (uint256) {
        return items.length;
    }

    /**
     *@notice This function calculates the total sales of all items that are not sold out.
     *@return The total sales of all items that are not sold out.
     */

    function totalSales() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < items.length; i++) {
            if (!items[i].isSoldOut) {
                total += items[i].price * items[i].quantity;
            }
        }
        return total;
    }
}
