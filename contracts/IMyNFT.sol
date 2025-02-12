// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title IMyNFT
 * @dev This interface demonstrates the use of an interface in Solidity so that other contracts can interact with the MyNFT contract.
 * @author hy
 * @notice Date: 12/02/2025
 */
interface IMyNFT is IERC721 {
    function mint(address to, uint256 id) external;
    function burn(uint256 id) external;
}
