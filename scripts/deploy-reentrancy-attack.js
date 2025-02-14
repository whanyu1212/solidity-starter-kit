const { ethers } = require("hardhat");

async function main() {
    // deployer is a pre-funded account that holds the Ether to be deposited into the Victim contract
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", await deployer.getAddress());

    // Deploy the Victim contract first
    const victimContractFactory = await ethers.getContractFactory("Victim");
    const victimContractInstance = await victimContractFactory.deploy();
    await victimContractInstance.waitForDeployment();
    console.log("Victim deployed at:", victimContractInstance.target);

    // Now deploy the Attacker contract using the deployed victim contract's address
    const attackerContractFactory = await ethers.getContractFactory("Attacker");
    const attackerContractInstance = await attackerContractFactory.deploy(victimContractInstance.target);
    await attackerContractInstance.waitForDeployment();
    console.log("Attacker deployed at:", attackerContractInstance.target);

    // Deposit Ether into Victim contract
    await victimContractInstance.deposit({ value: ethers.parseEther("100") });
    console.log("Deposited 1000 Ether into Victim");

    // Display Victim contract balance after deposit
    const victimBalance = await ethers.provider.getBalance(victimContractInstance.target);
    console.log("Victim contract balance:", ethers.formatEther(victimBalance), "Ether");

    // Execute the attack with 1 Ether
    await attackerContractInstance.attack({ value: ethers.parseEther("1") });
    console.log("Attack completed");

    // Display Victim contract balance after attack
    const victimBalanceAfterAttack = await ethers.provider.getBalance(victimContractInstance.target);
    console.log("Victim contract balance after attack:", ethers.formatEther(victimBalanceAfterAttack), "Ether");
}

try {
    main()
      .then(() => process.exit(0))
      .catch(error => {
          console.error(error);
          process.exit(1);
      });
} catch (error) {
    console.error(error);
    process.exit(1);
}