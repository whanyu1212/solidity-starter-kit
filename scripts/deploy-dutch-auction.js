const { ethers } = require("hardhat");

async function main() {
  // simulate 3 accounts, the organizer, the seller, and the buyer
  const [organizer, seller, buyer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", organizer.getAddress());
  console.log("Seller's address: ", seller.getAddress());
  console.log("Buyer's address: ", buyer.getAddress());

  // Deploy ERC20 Token
  const Token = await ethers.getContractFactory("ModifiedERC20");
  const token = await Token.deploy("TestToken", "TTK", ethers.parseEther("1000000"));
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log("Token deployed to:", tokenAddress);

  // Deploy NFT
  const NFT = await ethers.getContractFactory("MyNFT");
  const nft = await NFT.deploy("TestNFT", "TNFT");
  await nft.waitForDeployment();
  const nftAddress = await nft.getAddress();
  console.log("NFT deployed to:", nftAddress);

  // Deploy Dutch Auction
  const DutchAuction = await ethers.getContractFactory("DutchAuction");
  const auction = await DutchAuction.deploy(tokenAddress, nftAddress);
  await auction.waitForDeployment();
  const auctionAddress = await auction.getAddress();
  console.log("DutchAuction deployed to:", auctionAddress);

  // Setup: Transfer tokens from deployer to buyer
  await token.transfer(buyer.address, ethers.parseEther("10000"));
  console.log("Transferred tokens to buyer");

  // Setup: Mint NFT to seller (only mint once)
  await nft.connect(seller).mint(seller.address, 1);
  console.log("Minted NFT #1 to seller");

  await token.connect(buyer).approve(auctionAddress, ethers.parseEther("10000"));
  await nft.connect(seller).approve(auctionAddress, 1);
  console.log("Approvals completed");

  // Create auction
  const startPrice = ethers.parseEther("100");
  const endPrice = ethers.parseEther("10");
  const duration = 7 * 24 * 60 * 60; // 7 days in seconds

  await auction.connect(seller).registerAuction(
    1, // tokenId
    startPrice,
    endPrice,
    duration
  );

  console.log("Auction created for NFT #1");
  console.log("Start price:", ethers.formatEther(startPrice));
  console.log("End price:", ethers.formatEther(endPrice));
  console.log("Duration lasted:", duration / (24 * 60 * 60), "days");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });