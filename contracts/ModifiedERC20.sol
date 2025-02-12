// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Extending base ERC20 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Extending base ERC721 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Instead of copying the source code, we import it from OpenZeppelin library
// to avoid any errors in the future due to changes in the source code
/**
 * @title ModifiedERC20
 * @dev This contract demonstrates an extension of the ERC20 token with additional features.
 * @author hy
 * @notice Date: 08/02/2025
 */
contract ModifiedERC20 is ERC20 {
    // --------------------------------------------------
    // State Variables
    // --------------------------------------------------
    // Owner and constants
    address private _owner;
    uint8 private constant _decimals = 18; // 18 is the standard number of decimals for ERC20 tokens

    // Mapping
    mapping(address => bool) private _frozenAccounts; // Mapping to store frozen accounts

    // --------------------------------------------------
    // Events
    // --------------------------------------------------
    event AccountFrozen(address indexed account);
    event AccountUnfrozen(address indexed account);

    // In the constructor, we are calling the constructor of the base ERC20 contract
    // giving the token a name and a symbol and minting some initial supply
    // 1000000 * 10^18 = 1,000,000,000,000,000,000,000,000 (wei equivalent)
    // removed hardcoded values and added parameters to the constructor
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    /**
     * @notice This function checks if the caller is the owner of the contract.
     */
    function _checkOwner() internal view {
        if (_owner != msg.sender) {
            revert();
        }
    }

    /**
     * @notice This modifier checks if the caller is the owner of the contract.
     */
    modifier onlyOwner() {
        _checkOwner(); // pre-condition
        _; // placeholder for original function execution
        // if check passes (the caller is owner),
        // the original function is executed
    }

    /**
     * @notice This function mints new tokens and assigns them to the specified account.
     * @param to The account to which the new tokens will be assigned.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice This function burns tokens from the specified account.
     * @param from The account from which the tokens will be burned.
     * @param amount The amount of tokens to burn.
     */
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    /**
     * @notice This function freezes the specified account.
     * @param account The account to be frozen.
     */
    function freezeAccount(address account) public onlyOwner {
        require(!_frozenAccounts[account], "Account is already frozen");
        _frozenAccounts[account] = true; // change the value in the mapping
        emit AccountFrozen(account); // This emits an indexed event
    }

    /**
     * @notice This function unfreezes the specified account.
     * @param account The account to be unfrozen.
     */
    function unfreezeAccount(address account) public onlyOwner {
        require(_frozenAccounts[account], "Account is not frozen");
        _frozenAccounts[account] = false; // change the value in the mapping
        emit AccountUnfrozen(account);
    }

    /**
     * @notice This function checks if the specified account is frozen.
     * @param account The account to check.
     * @return A boolean value indicating whether the account is frozen.
     */
    function isAccountFrozen(address account) public view returns (bool) {
        return _frozenAccounts[account];
    }

    /**
     * @notice This function transfers tokens from the sender to the recipient.
     * @param recipient The account to which the tokens will be transferred.
     * @param amount The amount of tokens to transfer.
     * @return A boolean value indicating whether the transfer was successful.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        // Check whether the sender account is frozen
        require(!isAccountFrozen(msg.sender), "Account is frozen");

        // reuse the inner transfer function from the base contract
        // base contract already has a _balance mapping created
        _transfer(msg.sender, recipient, amount);
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @notice This function transfers tokens from the sender to the recipient using the sender's allowance.
     * @param sender The account from which the tokens will be transferred.
     * @param recipient The account to which the tokens will be transferred.
     * @param amount The amount of tokens to transfer.
     * @return A boolean value indicating whether the transfer was successful.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        require(!isAccountFrozen(sender), "Account is frozen");

        // Handle allowance and transfer using base contract functions
        // update sender's allowance
        _spendAllowance(sender, msg.sender, amount);
        // transfer the amount from sender to recipient
        _transfer(sender, recipient, amount);

        return true;
    }
}
