import { ethers } from "hardhat";
import * as dotenv from "dotenv";

async function main() {
  const reward_period_minutes = 10;
  const lock_period_minutes = 30;
  const reward_procents = 5;

  const SuperStaking = await ethers.getContractFactory("SuperStaking");
  const superStaking = await SuperStaking.deploy(
    process.env.UNISWAP_CONTRACT as string,
    process.env.SUPER_TOKEN_CONTRACT as string,
    reward_period_minutes, lock_period_minutes, reward_procents);

  await superStaking.deployed();

  console.log("superStaking deployed to:", superToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
