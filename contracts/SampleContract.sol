// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicContract {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }

    function setName(string memory _name) public {
        name = _name;
    }

    // Allow contract to receive Ether
    receive() external payable {}

    // Function to send Ether to an address
    function sendEther(address payable _to, uint256 _amount) public {
        require(address(this).balance >= _amount, "Insufficient balance");
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

    /**
    There's a key difference between address(this) and msg.sender:

    address(this): Refers to the current contract's address
    msg.sender: Refers to the address that called/initiated the current function
     */

    // Function to check contract's balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
