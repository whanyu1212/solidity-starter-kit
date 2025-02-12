# solidity-starter-kit
A repository for me to document my learning on solidity and smart contract

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

Install hardhat locally for testing, compilation and deployment (alternatively, you can use Truffle)
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

### Learning Points

<details>
  <summary>Basic Blockchain Concept</summary>
  <br>

A decentralized, public ledger where information (transactions, contracts, etc.) is recorded permanently

**What is a "Block" and a "Chain"?**

- A **Block** = A batch of transactions that are grouped together, verified, and added to the ledger.
- A **Chain** = A sequence of blocks linked together, forming a history of all transactions.

Each block contains:

1. Transactions – Actions like payments, smart contract executions, or NFT transfers.
2. A Reference to the Previous Block – This links it to the previous block, forming a chain.
3. A Unique Code (Hash) – A digital fingerprint ensuring the block's integrity.
4. Once a block is added to the chain, it cannot be changed—which is what makes blockchain secure and trustworthy.

<br>

**<u>Blockchain vs Traditional Systems</u>**
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

**<u>Key Differences Between Blockchain & Cloud Deployment:</u>**
| Feature            | Cloud Deployment (AWS, GCP, etc.) | Blockchain Deployment (Ethereum, Solana, etc.) |
|--------------------|----------------------------------|----------------------------------------------|
| **Ownership**      | Owned & controlled by a company | Decentralized, no single owner              |
| **Immutability**   | Code can be updated/redeployed  | Once deployed, cannot be changed            |
| **Availability**   | Dependent on cloud provider uptime | Always available as long as the network exists |
| **Execution**      | Runs on centralized servers     | Runs on decentralized nodes (miners/validators) |
| **Trust**          | Users must trust the cloud provider | Trustless – code executes as programmed  |
| **Security**       | Protected by the provider’s security measures | Secured by cryptography and consensus mechanisms |
| **Scaling**        | Can scale dynamically with resources | Limited scalability (depends on network throughput) |
| **Data Storage**   | Stored in databases (SQL, NoSQL) | Stored on-chain (expensive) or off-chain (IPFS, Arweave) |
| **Cost**           | Pay for compute/storage based on usage | Pay **gas fees** for every interaction  |
| **Transparency**   | Code execution is private unless made public | Everything is publicly verifiable on-chain |

<br>

</details>

<br>

<details>
  <summary>Data Locations & Best Practices</summary>

  1. #### Storage
   - Persistent storage (like a hard drive)
   - Most expensive gas cost
   - State variables are storage by default
   - Persists between function calls
  2. #### Memory
   - Temporary storage (like RAM)
   - Medium gas cost
   - Cleared after function execution
   - Used for function parameters and local variables
  3. #### Calldata
   - Read-only temporary storage
   - Lowest gas cost
   - Used for function parameters
   - Cannot be modified

</details>

<br>

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