const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  // Get signers
  const [owner, user1, user2] = await ethers.getSigners();

  // Deploy first token
  const Token1 = await ethers.getContractFactory("ModifiedER20");
  const token1 = await Token1.deploy();
  await token1.waitForDeployment();

  // Deploy second token
  const Token2 = await ethers.getContractFactory("ModifiedER20");
  const token2 = await Token2.deploy();
  await token2.waitForDeployment();

  // Transfer initial balances
  await token1.transfer(user1.address, ethers.parseEther("1000"));
  await token2.transfer(user2.address, ethers.parseEther("1000"));

  // Log initial balances
  console.log("Initial balances:");
  console.log("User1 Token1:", ethers.formatEther(await token1.balanceOf(user1.address)));
  console.log("User2 Token2:", ethers.formatEther(await token2.balanceOf(user2.address)));

  // Deploy TokenSwap
  const TokenSwap = await ethers.getContractFactory("TokenSwap");
  const tokenSwap = await TokenSwap.deploy(
    await token1.getAddress(),
    user1.address,
    ethers.parseEther("100"),
    await token2.getAddress(),
    user2.address,
    ethers.parseEther("100")
  );
  await tokenSwap.waitForDeployment();

  console.log("TokenSwap deployed to:", await tokenSwap.getAddress());

  // Approve TokenSwap contract
  // approve updates the allowance of the spender, please refer to the ERC20 standard
  await token1.connect(user1).approve(
    await tokenSwap.getAddress(),
    ethers.parseEther("100")
  );
  await token2.connect(user2).approve(
    await tokenSwap.getAddress(),
    ethers.parseEther("100")
  );

  // Execute swap
  // default signer is owner, so we need to connect to user1 to swap user1's tokens
  // either user can trigger the swap
  await tokenSwap.connect(user1).swap();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });