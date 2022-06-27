import { ethers } from "hardhat";
import * as dotenv from "dotenv";

async function main() {
  const reward_period_minutes = 1;
  const lock_period_minutes = 7;
  const reward_procents = 5;

  const MyStaking = await ethers.getContractFactory("MyStaking");
  const myStaking = await MyStaking.deploy(
    process.env.UNISWAP_CONTRACT!,
    process.env.SUPER_TOKEN_CONTRACT!,
    reward_period_days,
    lock_period_days,
    reward_procents);

  await myStaking.deployed();

  console.log("myStaking deployed to:", myStaking.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
