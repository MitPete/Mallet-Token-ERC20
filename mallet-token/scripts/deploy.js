const hre = require("hardhat");

async function main() {
  const MalletToken = await hre.ethers.getContractFactory("MalletToken");
  const malletToken = await MalletToken.deploy(100000000, 50);

  await malletToken.deployed();

  console.log("Mallet Token deployed: ", malletToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});