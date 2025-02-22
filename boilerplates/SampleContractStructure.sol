// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Not enough funds for transfer. Requested `requested`,
/// but only `available` available.
error NotEnoughFunds(uint requested, uint available);

// More custom errors can be found at https://docs.soliditylang.org/en/latest/contracts.html#errors

contract TestContract {
    // State variables
    uint public storedData = 100;
    mapping(address => uint) public balances;

    enum State {
        Created,
        Locked,
        Inactive
    } // Enum

    struct Voter {
        // Struct
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    // Constructor, similar to __init__ in Python
    constructor(uint256 _value) {
        storedData = _value;
    }
    // Events
    // For EVM logging
    event HighestBidIncreased(address bidder, uint amount);

    //----------------------------Pure, View, and Regular Functions----------------------------
    // Pure function - only works with its parameters
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    // View function - can read state but not modify it
    function getStoredDataPlus(uint a) public view returns (uint) {
        return storedData + a; // Can read storedData
    }

    // Regular function - can modify state
    function setStoredData(uint _value) public {
        storedData = _value; // Can modify state
    }

    //-----------------------Miscellaneous Functions and Free Functions-----------------------

    // Function to call a free function
    function useHelper(uint x) public pure returns (uint) {
        return helper(x); // Direct call to the free function
    }

    // Function to emit an event
    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }

    // revert and error message
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        if (balance < amount) revert NotEnoughFunds(amount, balance);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // ...
    }
}

// Helper function defined outside of a contract
function helper(uint x) pure returns (uint) {
    return x * 2;
}
