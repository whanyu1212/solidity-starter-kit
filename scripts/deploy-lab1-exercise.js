const { ethers } = require("hardhat");

async function main() {
    // Deploy contract Lab1Exercise
    const Lab1 = await ethers.getContractFactory("Lab1Exercise");
    const lab1 = await Lab1.deploy();
    await lab1.waitForDeployment();
    console.log("Lab1Exercise deployed to:", await lab1.getAddress());

    // add item
    const sampleItems = [
        { name: "item1", price: 10, quantity: 5, isSoldOut: false },
        { name: "item2", price: 20, quantity: 10, isSoldOut: false },
        { name: "item3", price: 30, quantity: 15, isSoldOut: false },
        // add more items if needed
    ];

    // Loop through each item and add it using the contract function
    for (const item of sampleItems) {
        const addItemTx = await lab1.addItem(item);
        await addItemTx.wait();
        console.log("Item added:", item);
    }

    // Get the number of items
    const numItems = await lab1.numberOfItems();
    console.log("Number of items added:", numItems.toString());

    // Set one of the items as sold out
    await lab1.soldOut(1);
    console.log("Item at index 1 is marked as sold out");

    // Check if item 2 is indeed sold out
    const item2 = await lab1.items(1);
    console.log("Item2 sold out status:", item2.isSoldOut);

    // Calculate total price
    const totalSales = await lab1.totalSales();
    console.log("Total price is:", totalSales.toString());

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });