const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
    // Get signers
    const [owner, user1] = await ethers.getSigners();
    console.log("Deploying with:", await owner.getAddress());

    // Deploy NFT contract
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const nft = await MyNFT.deploy();
    await nft.waitForDeployment();
    console.log("NFT deployed to:", await nft.getAddress());

    // Mint NFT
    const tokenId = 1;
    await nft.mint(user1.address, tokenId);
    console.log(`Minted NFT #${tokenId} to:`, user1.address);

    // Check ownership
    const owner1 = await nft.ownerOf(tokenId);
    console.log(`Owner of NFT #${tokenId}:`, owner1);

    // Burn NFT (should fail as owner tries to burn user1's NFT)
    // Only the owner of the NFT can burn it
    try {
        await nft.burn(tokenId);
    } catch (error) {
        console.log("Burn failed as expected (wrong owner)");
    }

    // Burn NFT (should succeed as user1 burns their own NFT)
    await nft.connect(user1).burn(tokenId);
    console.log(`NFT #${tokenId} burned by user1`);

    // Verify burn
    try {
        await nft.ownerOf(tokenId);
    } catch (error) {
        console.log("NFT no longer exists (burned)");
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });