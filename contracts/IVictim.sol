// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVictim {
    function deposit() external payable;
    function withdrawAll() external;
    function getBalance() external view returns (uint256);
    function getUserBalance(address _user) external view returns (uint256);
}
