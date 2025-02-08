# solidity-starter-kit
a repository for me to document my learning on solidity and smart contract

### Learning Points
<details>
  <summary>ERC20 & Fungible Tokens</summary>
  <br>
  
  #### Basic Concept:
  <br>

  Fungible tokens are digital assets that are interchangeable with each other and have **<u>uniform value</u>**, i.e., each token holds the same value as another of its kind (e.g., 1 USDT = 1 USDT). Apart from interchangeability, other key characteristics include:

  - Can be broken into smaller units (e.g., 0.0001 ETH)
  - Should be built using predefined smart contract standards (e.g., ERC20)
  - Easily traded on exchanges and used for transactions (liquidity)

  <br>
  
  ERC20 defines a standard set of functions and events that all **<u>fungible tokens</u>** should implement. Fungible means that each token is **<u>interchangeable</u>** with another (like currency, a.k.a **代币**).

  This standard allows different tokens to interact with decentralized applications (dApps), exchanges, and other smart contracts in a consistent and predictable manner. Wallets and exchanges can easily integrate any **<u>ERC20-compliant</u>** token.

  It provides the basic functionality for <u>transferring tokens, approving spending by other accounts, and querying balances and total supply.</u>

  The ERC20 contract in OpenZeppelin is often implemented as an **<u>abstract contract</u>** because it provides a basic framework but leaves some implementation details to be defined in derived contracts, e.g., Lab2's example. Note that abstract contract cannot be deployed directly.
</details>