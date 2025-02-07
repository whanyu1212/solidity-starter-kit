const hre = require("hardhat");

async function main() {
  // Get contract factory
  const Lab1Exercise = await hre.ethers.getContractFactory("Lab1");
  
  // Deploy contract
  const lab1 = await Lab1Exercise.deploy();
  
  // Wait for deployment
  await lab1.waitForDeployment();
  
  // Get deployed address
  const address = await lab1.getAddress();
  console.log("Lab1 deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });