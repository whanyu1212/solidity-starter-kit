// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Victim
 * @dev This contract demonstrates how to prevent reentrancy attacks in Solidity.
 * @author hy
 * @notice Date: 14/02/2025
 */
contract Victim {
    mapping(address => uint256) private userBalances;

    /**
     * @notice This function allows users to deposit Ether into the contract.
     */
    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }

    /**
     * @notice This function allows users to withdraw their balance from the contract.
     */
    function withdrawAll() external {
        uint256 balance = getUserBalance(msg.sender);
        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");

        userBalances[msg.sender] = 0;
    }

    /**
     * @notice This function returns the balance of the contract.
     * @return The balance of the contract.
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice This function returns the balance of the specified user.
     * @param _user The address of the user.
     * @return The balance of the user.
     */
    function getUserBalance(address _user) public view returns (uint256) {
        return userBalances[_user];
    }
}
