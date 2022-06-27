import 'dotenv/config';
import { types } from "hardhat/config";
import { task } from "hardhat/config";

task("getStakerState", "Get info about stakes")
  .addParam("staker", "address of staker")
  .setAction(async (args, hre) => {
  const accounts = await hre.ethers.getSigners();
  const contract = await hre.ethers.getContractAt(
    "IMyStaking",
    process.env.CONTRACT_ACCAUNT!);
    const tx = await contract.stakes(args.staker);
  // tx.wait();
  console.log(tx);
});
