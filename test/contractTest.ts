import { expect } from "chai";
import { ethers } from "hardhat";
import { Signer, Contract } from "ethers";
import * as dotenv from "dotenv";

describe("Test SuperStaking contract", function () {

  let superStaking: Contract;
  let superToken: Contract;
  let accounts: Signer[];
  let superTokenAddr = process.env.SUPER_TOKEN_CONTRACT as string;

  it("Should deploy SuperStaking contract", async function () {
    const SuperStaking = await ethers.getContractFactory("SuperStaking");
    superStaking = await SuperStaking.deploy(process.env.UNISWAP_CONTRACT as string,
      superTokenAddr, 10, 20, 5);
    await superStaking.deployed();
    console.log(superStaking.address);
  });

  it("Should mint tokens from SuperToken to SuperStaking", async function () {
    accounts = await ethers.getSigners();
    superToken = await ethers.getContractAt("SuperToken",
                              process.env.SUPER_TOKEN_CONTRACT as string,
                              accounts[0]);
    await expect(superToken.mint(superStaking.address, 10000000000))
        .to.emit(superToken, "Transfer")
        .withArgs(ethers.constants.AddressZero, superStaking.address, 10000000000);
        const balance = await superToken.connect(accounts[1])
        .balanceOf(superStaking.address);
        expect(balance).to.equal(10000000000);
  });
});
