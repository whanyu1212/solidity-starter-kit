// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// In Solidity, all code must be inside a contract
contract Lab1Exercise {
    struct item {
        string name;
        uint256 price;
        uint256 quantity;
        bool isSoldOut;
    }

    item[] public items;

    function addItem(item memory newItem) public {
        items.push(newItem);
    }

    function soldOut(uint256 index) public {
        items[index].isSoldOut = true;
    }

    function numberOfItems() public view returns (uint256) {
        return items.length;
    }

    function totalSales() public view returns (uint256){
        uint256 total = 0;
        for (uint256 i = 0; i < items.length; i++) {
            if (!items[i].isSoldOut) {
                total += items[i].price * items[i].quantity;
            }
        }
        return total;   
    }
}