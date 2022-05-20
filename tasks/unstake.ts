import 'dotenv/config';
import { types } from "hardhat/config";
import { task } from "hardhat/config";

task("unstake", "Unstake one stake by ID")
  .addParam("requesting", "ID of accaunt in array in .env")
  .addParam("stakeId", "The ID of stake")
  .setAction(async (args, hre) => {
  const accounts = await hre.ethers.getSigners();
  const contract = await hre.ethers.getContractAt("SuperStaking",
  process.env.CONTRACT_ACCAUNT!, accounts[args.requesting]);
  contract.on("Unstake", (to, amount, event) => {
    console.log({
      to: to,
      amount: amount.toNumber(),
      data: event
    });
  });
  const tx = await contract.unstake(args.stakeId);
  tx.wait();
});
