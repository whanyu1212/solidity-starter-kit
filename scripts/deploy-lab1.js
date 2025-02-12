const { ethers } = require("hardhat");

async function main() {
    // Deploy contract Lab1
    const Lab1 = await ethers.getContractFactory("Lab1");
    const lab1 = await Lab1.deploy();
    await lab1.waitForDeployment();
    console.log("Lab1 deployed to:", await lab1.getAddress());

    // Set price and quantities
    const setPriceTx = await lab1.setPrice(20);
    await setPriceTx.wait();
    console.log("Price set to 20");

    const QuantitiesTx = await lab1.setQuantities([10, 20, 30]);
    await QuantitiesTx.wait();
    console.log("Quantities set to [10, 20, 30]");

    // Test total price
    const totalTx = await lab1.totalPrice();
    console.log("Total price is:", totalTx.toString());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });