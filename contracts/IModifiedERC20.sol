// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title IModifiedERC20
 * @dev This interface demonstrates the use of an interface in Solidity so that other contracts can interact with the ModifiedERC20 contract.
 * @author hy
 * @notice Date: 12/02/2025
 */
interface IModifiedERC20 is IERC20 {
    // Additional functions from your ModifiedERC20 contract
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
    function freezeAccount(address account) external;
    function unfreezeAccount(address account) external;
    function isAccountFrozen(address account) external view returns (bool);
}
