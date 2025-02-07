// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// In Solidity, all code must be inside a contract
contract Lab1 {
 uint256 public price;
 uint256[] quantities;

 function setPrice(uint256 val) public {
   price = val;
 }

 function setQuantities(uint256[] memory arr) public {
   quantities = arr;
 }

 function totalPrice() public view returns (uint256) {
   uint256 total = 0;
   for (uint256 i = 0; i < quantities.length; i++) {
     total += quantities[i] * price;
   }
   return total;
 }
}