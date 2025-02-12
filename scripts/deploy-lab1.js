const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
    // Deploy contract
    const ModifiedER20 = await ethers.getContractFactory("ModifiedER20");
    const token = await ModifiedER20.deploy();
    await token.waitForDeployment();
    
    // Get player accounts
    const [owner, player1, player2] = await ethers.getSigners();
    
    // Test transfers
    console.log("\n=== Testing Transfers ===");
    await token.transfer(player1.address, ethers.parseEther("1000"));
    console.log("Transferred 1000 tokens to player1");
    
    // Test freeze
    console.log("\n=== Testing Freeze ===");
    await token.freezeAccount(player1.address);
    console.log("Frozen player1 account");
    
    // Try transfer from frozen account (should fail)
    try {
        await token.connect(player1).transfer(player2.address, ethers.parseEther("100"));
    } catch (error) {
        console.log("Transfer from frozen account failed as expected");
    }
    
    // Check balances
    const ownerBalance = await token.balanceOf(owner.address);
    const player1Balance = await token.balanceOf(player1.address);
    
    console.log("\n=== Final Balances ===");
    console.log(`Owner: ${ethers.formatEther(ownerBalance)} MERC`);
    console.log(`Player1: ${ethers.formatEther(player1Balance)} MERC`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });