<!-- omit in toc -->
# Solidity Starter Kit
A repository for me to document my learning on solidity and smart contract

<!-- omit in toc -->
## Table of Contents
- [Setting up Solidity development environment locally](#setting-up-solidity-development-environment-locally)
- [Basic Blockchain Concept](#basic-blockchain-concept)
  - [Blockchain vs Traditional Systems](#blockchain-vs-traditional-systems)
  - [Solving Double Spending](#solving-double-spending)
  - [Proof-of-work (PoW) mechanism](#proof-of-work-pow-mechanism)
- [Ethereum Fundamentals](#ethereum-fundamentals)
  - [Ether Units](#ether-units)
  - [Data Locations \& Best Practices](#data-locations--best-practices)
- [Functions](#functions)
  - [Structure](#structure)
  - [Visibility](#visibility)
  - [Constructor and Destructor Functions](#constructor-and-destructor-functions)
  - [Fallback Function](#fallback-function)
  - [Function overloading](#function-overloading)
  - [Function Modifier](#function-modifier)
- [Events](#events)
- [Global \& Contextual Variables (and functions)](#global--contextual-variables-and-functions)
- [NatSpec Tags](#natspec-tags)
- [Understanding inheritance, abstract contracts and interfaces](#understanding-inheritance-abstract-contracts-and-interfaces)
  - [Interfaces](#interfaces)
  - [Abstract Contracts](#abstract-contracts)
  - [Inheritance](#inheritance)
  - [Function overriding](#function-overriding)
- [Token Standards](#token-standards)
  - [ERC20 \& Fungible Tokens](#erc20--fungible-tokens)
  - [ERC721 \& Non-Fungible Tokens](#erc721--non-fungible-tokens)
---

### Setting up Solidity development environment locally
Remix IDE (web-based) is tailored for Solidity Smart Contract development but it is not suited for full-fledged front-end development. I still prefer to do the development work locally whenever I need to build a proper project.

Install solidity
```bash
npm install -g solc
```

Install ganache for local blockchain simulator (allows quick contract testing without actual wallets)
```bash
npm install -g ganache
```

Initialize Node.js project
```bash
# Initialize Node.js project, this creates package.json and enables npm dependencies
# Make sure you are in your root folder
npm init -y 
```

Install hardhat locally for testing, compilation and deployment (alternatively, you can use Truffle but it is a sunset project)
```bash
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
```

initialize hardhat project and automate the folder directory set up: it creates hardhat.config.js, contracts/ , scripts/ and test/ folders under the root directory
```bash
npx hardhat init
```
Now your project root folder will look something like the following:
```
your-project/
├── contracts/
├── scripts/
├── test/
├── hardhat.config.js
├── package.json
└── node_modules/
```

---

### Basic Blockchain Concept

A decentralized, public ledger where information (transactions, contracts, etc.) is recorded permanently.

**What is a "Block" and a "Chain"?**

- A **Block** = A batch of transactions that are grouped together, verified, and added to the ledger.
- A **Chain** = A sequence of blocks linked together, forming a history of all transactions.

Each block contains:

1. Transactions – Actions like payments, smart contract executions, or NFT transfers.
2. A Reference to the Previous Block – This links it to the previous block, forming a chain.
3. A Unique Code (Hash) – A digital fingerprint ensuring the block's integrity.
4. Once a block is added to the chain, it cannot be changed—which is what makes blockchain secure and trustworthy.

<br>

#### Blockchain vs Traditional Systems

| Feature          | Traditional Systems (Banks, Cloud, etc.) | Blockchain (Decentralized, On-Chain) |
|-----------------|----------------------------------|--------------------------------|
| **Control**      | Centralized authority (bank, company) | No single owner, fully distributed |
| **Security**     | Can be hacked, single point of failure | Highly secure, no central point to attack |
| **Trust**        | Requires trust in institutions | Trustless, automated verification |
| **Transparency** | Private records | Fully public and auditable |
| **Data Changes** | Can be altered/deleted | Immutable, cannot be changed |
| **Middlemen**    | Needed (banks, payment processors) | Not needed, peer-to-peer transactions |
| **Availability** | Can go offline | Always online as long as nodes exist |

<br>

#### Solving Double Spending

illustration:
<img src="./pics/1742827531253.jpg" alt="Constructor example" width="400" />

**Possible Solutions:**
1. A leader decides the order of the transaction (the event of a leader server failure?)
2. A leader decides the order of transactions **+** The next server becomes a leader if the current leader doesn't suggest the next
transaction for 10 seconds (What if one server may believe the leader has changed, while another may not?)
3. A leader decides the order of transactions **+** The next server becomes a leader if the current leader doesn't suggest a next
transaction for 10 seconds **+** A leader collects confirmations from other servers about the order suggestion (what if a server lies?)

<br>

**Concensus Algorithm:**
- Bitcoin uses the Nakamoto consensus mechanism: a combination of **Proof-of-work** and **Longest chain rule**
- Ethereum switched a Proof-of-Stake mechanism since Sept 2022, claims to have reduced energy consumption significantly compared to PoW, while maintaining network security through economic incentives.

#### Proof-of-work (PoW) mechanism
1. **Block Formation**
   - Transaction Collection: Miners collect pending transactions and organize them into a block.

   - Block Header: This contains metadata such as the previous block's hash, a timestamp, the Merkle root of the transactions, a nonce, and other fields.

2. **The Hash Puzzle**
   - Hash Function: The block header is fed into a cryptographic hash function (Bitcoin uses SHA-256) which produces a fixed-size output (a hash).

   - Difficulty Target: The network sets a difficulty target. For a block to be valid, its hash must be lower than this target. In practice, this is often represented as the hash having a certain number of leading zeros.

   - Nonce: The nonce is a number that miners adjust to change the block header's hash output. By incrementing the nonce, miners generate different hashes until one meets the difficulty condition.

3. **The Mining Process**
   - Iteration: Miners try different nonce values (and sometimes adjust other parts of the block header) in a trial-and-error process.

   - Computational Work: Because there is no shortcut to predict the correct nonce, miners must compute many hashes until they find one that satisfies the condition. This work is deliberately resource-intensive.

   - Block Broadcast: Once a valid nonce is found, the block is broadcast to the network for validation. Other nodes check the block's hash and confirm that it meets the difficulty criteria.

4. **Security and Consensus**
   - Costly Attack: The high computational cost makes it economically impractical for an attacker to alter past blocks since they would need to redo the work for that block and all subsequent blocks.

   - Longest Chain Rule: The network follows the chain with the most accumulated work, ensuring that the block with valid proof-of-work is accepted even if two blocks are found nearly simultaneously.

--- 

### Ethereum Fundamentals

#### Ether Units

Ether Units Explained:
- **Ether**: The main currency of Ethereum
- **Wei**: The smallest unit of Ether
  - 1 Ether = 1,000,000,000,000,000,000 wei (1e18 wei)
- **Gwei**: Commonly used for gas prices
  - 1 Gwei = 1,000,000,000 wei (1e9 wei)
  - 1 Ether = 1,000,000,000 Gwei

<br>


#### Data Locations & Best Practices

1. **Storage**
   - Persistent storage (like a hard drive)
   - Most expensive gas cost
   - State variables are storage by default
   - Persists between function calls

2. **Memory**
   - Temporary storage (like RAM)
   - Medium gas cost
   - Cleared after function execution
   - Used for function parameters and local variables

3. **Calldata**
   - Read-only temporary storage
   - Lowest gas cost
   - Used for function parameters
   - Cannot be modified

---

### Functions

#### Structure
- Input parameters
- Access Modifiers
- Output Parameters
  
<br>

#### Visibility

- `external`: It is part of our contract's interface and can be called from other contracts or transactions, but <u>cannot be called from within the contract</u> or at least not without an explicit reference to the object it is being called on.

- `public`: They can be called from other contracts or transactions, but additionally they <u>can be called internally</u>. This means you can use an implicit receiver of the message when invoking the method inside of a method.

- `internal` & `private`: Must use the implicit receiver or, in other words, **cannot be called on an object or on this**. The main difference between these two modifiers is that private functions are only visible within the contract in which they are defined, and not in derived contracts.

- `pure` & `view`: Will not alter the state of the contract's variables. `pure` functions do not read from the blockchain. They operate on data passed in or do not need any input. `view` functions can read data from the blockchain but they cannot write to the blockchain.

- `memory`: Not referencing anything located in our contract's persisted storage.

- `calldata`: Only needed when the function is declared as external and when the data type of the parameter is a reference type such as a mapping, struct, string, or array. Using value types like int or address do not require this label.

<br>

#### Constructor and Destructor Functions
- A constructor is called to initialize the smart contract when the smart contract is deployed.

<img src="./pics/B19140_06_11.jpg" alt="Constructor example" width="400" />

<br>

#### Fallback Function
- A contract can have **exactly one** fallback function
- An unnamed external function without any input or output parameters
- Executes the fallback function if none of the other functions match the intended function calls

<img src="./pics/B19140_06_13.jpg" alt="Fallback example" width="400" />

<br>

#### Function overloading
- you may define multiple functions with the same name but with different input parameter types
- Return types don’t count as part of the overloading resolution.
<img src="./pics/B19140_06_15.jpg" alt="Overloading" width="400" />

<br>

#### Function Modifier
- Similar to Aspect-oriented programming
- Change or augment the behavior of a function
<img src="./pics/B19140_06_16.jpg" alt="function modifier" width="400" />

---


### Events
- Used to track the execution of a transaction that’s sent to a contract
- DApps can subscribe and listen to these events through the Web3 JSON-RPC interface

<img src="./pics/B19140_06_17.jpg" alt="Events" width="400" />

---

### Global & Contextual Variables (and functions)

| Variable/Function | Type | Description |
|-------------------|------|-------------|
| `blockhash(uint blockNumber)` | `bytes32` | Returns the hash of the given block. Only works for the 256 most recent blocks, excluding current. |
| `block.coinbase` | `address payable` | Returns the current block miner's address. |
| `block.difficulty` | `uint` | Returns the current block's difficulty. |
| `block.gaslimit` | `uint` | Returns the current block's gas limit. |
| `block.number` | `uint` | Returns the current block's number. |
| `block.timestamp` | `uint` | Returns the current block's timestamp in seconds since Unix epoch. |
| `gasleft()` | `uint256` | Returns remaining gas in current execution. |
| `msg.data` | `bytes calldata` | Returns complete call data. |
| `msg.sender` | `address payable` | Returns the sender of the message (current call). |
| `msg.sig` | `bytes4` | Returns the first four bytes of the call data (function identifier). |
| `msg.value` | `uint` | Returns the number of Wei sent with the message. |
| `now` | `uint` | Returns the current block timestamp (alias for block.timestamp). |
| `tx.gasprice` | `uint` | Returns the gas price of the transaction. |
| `tx.origin` | `address payable` | Returns the sender of the transaction (full call chain). |

---

### NatSpec Tags

- **@title**  
  - **Purpose:** Provides a concise title or summary of the contract.  
  - **When to Use:** Always include this at the top of your contract so users quickly understand its purpose.

- **@dev**  
  - **Purpose:** Offers additional technical details meant for developers.  
  - **When to Use:** Use this to explain implementation details, inner workings, or important notes that are not immediately obvious from the code. This is especially useful for auditing or future maintenance.

- **@notice**  
  - **Purpose:** Describes what the contract or function does in user-friendly language.  
  - **When to Use:** Include it to inform end users or non-developer stakeholders about the behavior or purpose without exposing intricate internal details.

- **@param**  
  - **Purpose:** Documents function parameters; it describes the purpose of each argument passed to a function.  
  - **When to Use:** Always include one `@param` tag per parameter when a function accepts one or more parameters, specifying the parameter name and its role.

- **@return**  
  - **Purpose:** Explains what a function returns.  
  - **When to Use:** Use it in functions that return data to clarify what the returned value represents.

---

### Understanding inheritance, abstract contracts and interfaces

#### Interfaces
- Can extend from other interfaces, but it cannot inherit from other contracts
- Doesn’t have any function with an implementation
- All declared functions in an interface must be external
- Doesn’t have a constructor
- Cannot declare state variables
- Cannot declare modifiers

<img src="./pics/B19140_06_18.jpg" alt = "Interfaces" width="400" />

#### Abstract Contracts
- Similar to abstract class
- Defines all the methods for a contract to implement

#### Inheritance
- Can extend from other contracts, abstract contracts, or interfaces

<img src="./pics/B19140_06_19.jpg" alt="Inheritance" width="400" />

#### Function overriding
- Ability of one method in the subcontract to override the behaviors of the same method on the base contract

<img src="./pics/B19140_06_22.jpg" alt="function overriding" width="400" />

---

### Token Standards

#### ERC20 & Fungible Tokens

**Basic Concept:**

Fungible tokens are digital assets that are interchangeable with each other and have **<u>uniform value</u>**, i.e., each token holds the same value as another of its kind (e.g., 1 USDT = 1 USDT). Apart from interchangeability, other key characteristics include:

- Can be broken into smaller units (e.g., 0.0001 ETH)
- Should be built using predefined smart contract standards (e.g., ERC20)
- Easily traded on exchanges and used for transactions (liquidity)

ERC20 defines a standard set of functions and events that all **<u>fungible tokens</u>** should implement. Fungible means that each token is **<u>interchangeable</u>** with another (like currency, a.k.a **代币**).

This standard allows different tokens to interact with decentralized applications (dApps), exchanges, and other smart contracts in a consistent and predictable manner. Wallets and exchanges can easily integrate any **<u>ERC20-compliant</u>** token.

It provides the basic functionality for <u>transferring tokens, approving spending by other accounts, and querying balances and total supply.</u>

The ERC20 contract in OpenZeppelin is often implemented as an **<u>abstract contract</u>** because it provides a basic framework but leaves some implementation details to be defined in derived contracts, e.g., Lab2's example. Note that abstract contract cannot be deployed directly.

**ERC20 Token Standard Interface**

```mermaid
classDiagram
    class ERC20 {
        +string name
        +string symbol
        +uint8 decimals
        -uint256 _totalSupply
        -mapping(address => uint256) _balances
        -mapping(address => mapping(address => uint256)) _allowances
        
        +totalSupply() uint256
        +balanceOf(address owner) uint256
        +transfer(address to, uint256 value) bool
        +transferFrom(address from, address to, uint256 value) bool
        +approve(address spender, uint256 value) bool
        +allowance(address owner, address spender) uint256
    }
```

<br>


#### ERC721 & Non-Fungible Tokens
  <br>
  
  **Basic Concept:**
  <br>

  Non-fungible tokens (NFTs) are unique digital assets where **<u>no two tokens are identical</u>**. Unlike fungible tokens, each NFT has distinct characteristics and value. Key characteristics include:

  - Each token has a unique identifier (tokenId)
  - Cannot be subdivided (1 NFT remains 1 NFT)
  - Built using standards like ERC721 or ERC1155
  - Often represents ownership of digital or real-world assets

  <br>
  
  ERC721 defines the standard for **<u>non-fungible tokens</u>** on Ethereum. Each token is **<u>unique</u>** and represents distinct ownership (like digital art, collectibles, or real estate, a.k.a **非同质化代币**).

  This standard enables NFTs to be traded on marketplaces and integrated into various applications while maintaining their unique properties and ownership history.

  It provides functionality for <u>minting, transferring, and managing unique tokens, with each token having its own distinct ID and metadata</u>.

  <br>

  **ERC721 Token Standard Interface**

  ```mermaid
  classDiagram
      class ERC721 {
          +string name
          +string symbol
          -mapping(uint256 => address) _owners
          -mapping(address => uint256) _balances
          -mapping(uint256 => address) _tokenApprovals
          -mapping(address => mapping(address => bool)) _operatorApprovals
          
          +balanceOf(address owner) uint256
          +ownerOf(uint256 tokenId) address
          +safeTransferFrom(address from, address to, uint256 tokenId, bytes data)
          +safeTransferFrom(address from, address to, uint256 tokenId)
          +transferFrom(address from, address to, uint256 tokenId)
          +approve(address to, uint256 tokenId)
          +setApprovalForAll(address operator, bool approved)
          +getApproved(uint256 tokenId) address
          +isApprovedForAll(address owner, address operator) bool
      }
  ```


<br>


  ERC20 VS ERC721

  Key differences between ERC20 and ERC721:

  | Feature | ERC20 (Fungible) | ERC721 (Non-Fungible) |
  |---------|------------------|----------------------|
  | Uniqueness | All tokens identical | Each token unique |
  | Divisibility | Can be split (e.g., 0.5) | Cannot be split |
  | ID | No individual IDs | Each token has unique ID |
  | Value | Equal value per token | Value varies by token |
  | Transfer | Simple transfer | Transfer with specific ID |
  | Use Case | Currency, shares | Collectibles, art, property |

<br>

