import 'dotenv/config';
import { types } from "hardhat/config";
import { task } from "hardhat/config";

task("getStakerState", "Get info about stakes")
  .addParam("requesting", "ID of accaunt in array in .env")
  .setAction(async (args, hre) => {
  const accounts = await hre.ethers.getSigners();
  const contract = await hre.ethers.getContractAt("SuperStaking",
  process.env.CONTRACT_ACCAUNT!, accounts[args.requesting]);
  const tx = await contract.getStakerState();
  tx.wait();
  console.log(tx);
});
