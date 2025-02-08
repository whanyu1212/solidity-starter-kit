// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing the ERC721 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    constructor() ERC721("MyNFT", "MNFT") {}
    function mint(address to, uint256 id) external {
        _mint(to, id);
    }
    // we make use of the internal function in ERC721 to get the owner of the token
    //     contract ERC721 {
    //     // Internal mapping from token ID to owner address
    //     mapping(uint256 => address) private _owners;

    //     // Internal function that inheriting contracts can use
    //     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
    //         return _owners[tokenId];
    //     }
    // }
    function burn(uint256 id) external {
        require(msg.sender == _ownerOf(id), "not owner");
        _burn(id);
    }
}
