// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Extending base ERC20 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Extending base ERC721 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Instead of copying the source code, we import it from OpenZeppelin library
// to avoid any errors in the future due to changes in the source code
contract ModifiedER20 is ERC20 {
    // Adding a state variable called owner
    address private _owner;
    uint8 private constant _decimals = 18; // 18 is the standard number of decimals for ERC20 tokens
    mapping(address => bool) private _frozenAccounts; // Mapping to store frozen accounts
    event AccountFrozen(address indexed account);
    event AccountUnfrozen(address indexed account);

    // In the constructor, we are calling the constructor of the base ERC20 contract
    // giving the token a name and a symbol and minting some initial supply
    // 1000000 * 10^18 = 1,000,000,000,000,000,000,000,000 (wei equivalent)
    constructor() ERC20("ModifiedER20", "MERC") {
        uint8 decimals = _decimals;
        _owner = msg.sender; // Setting the owner to the address that deploys the contract
        _mint(msg.sender, 1000000 * 10 ** decimals);
    }

    // Adding a function to check if the caller is the owner
    // _ before the function name is a convention to indicate
    // that this function is private (or internal use only)
    function _checkOwner() internal view {
        if (_owner != msg.sender) {
            revert();
        }
    }

    // Middleware
    modifier onlyOwner() {
        _checkOwner(); // pre-condition
        _; // placeholder for original function execution
        // if check passes (the caller is owner),
        // the original function is executed
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    function freezeAccount(address account) public onlyOwner {
        require(!_frozenAccounts[account], "Account is already frozen");
        _frozenAccounts[account] = true; // change the value in the mapping
        emit AccountFrozen(account); // This emits an indexed event
    }

    function unfreezeAccount(address account) public onlyOwner {
        require(_frozenAccounts[account], "Account is not frozen");
        _frozenAccounts[account] = false; // change the value in the mapping
        emit AccountUnfrozen(account);
    }

    function isAccountFrozen(address account) public view returns (bool) {
        return _frozenAccounts[account];
    }

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

contract TokenSwap {
    // The interface of IERC is available because we imported the ERC20.sol file
    IERC20 public token1;
    address public owner1;
    uint256 public amount1;
    IERC20 public token2;
    address public owner2;
    uint256 public amount2;
    constructor(
        address _token1,
        address _owner1,
        uint256 _amount1,
        address _token2,
        address _owner2,
        uint256 _amount2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
        amount2 = _amount2;
    }
    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            // allowance reads current spending limit
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );
        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
