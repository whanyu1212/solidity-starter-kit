const { ethers } = require("hardhat");

async function main() {
    const [deployer, recipient] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    // Deploy the contract
    const BasicContract = await ethers.getContractFactory("BasicContract");
    const basicContract = await BasicContract.deploy("TestContract");
    await basicContract.waitForDeployment();
    console.log("Contract deployed to:", basicContract.target);

    // Send some ether to the contract
    const fundTx = await deployer.sendTransaction({
        to: basicContract.target,
        value: ethers.parseEther("10.0")
    });
    await fundTx.wait();
    console.log("Funded contract with 10 ETH");

    // Check contract balance
    let balance = await basicContract.getBalance();
    console.log("Contract balance:", ethers.formatEther(balance), "ETH");

    // Send 1 ETH to recipient
    const sendTx = await basicContract.sendEther(recipient.address, ethers.parseEther("1.0"));
    await sendTx.wait();
    console.log("Sent 1 ETH to recipient:", recipient.address);

    // Check balances after transfer
    balance = await basicContract.getBalance();
    console.log("Contract balance after transfer:", ethers.formatEther(balance), "ETH");
    
    const recipientBalance = await ethers.provider.getBalance(recipient.address);
    console.log("Recipient balance:", ethers.formatEther(recipientBalance), "ETH");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });