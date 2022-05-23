import { expect } from "chai";
import { ethers } from "hardhat";
import { Signer, Contract } from "ethers";
import * as dotenv from "dotenv";

describe("Test SuperStaking contract", function () {

  const reward_period_minutes = 10;
  const lock_period_minutes = 60;
  const reward_procents = 5;

  let superStaking: Contract;
  let superToken: Contract;
  let accounts: Signer[];
  let superTokenAddr = process.env.SUPER_TOKEN_CONTRACT as string;

  it("Should test reverts of constructor", async function () {
    const SuperStaking = await ethers.getContractFactory("SuperStaking");
    await expect(SuperStaking.deploy(ethers.constants.AddressZero,
      superTokenAddr, reward_period_minutes, lock_period_minutes, reward_procents))
      .to.be.revertedWith("Contract address can not be zero");
    await expect(SuperStaking.deploy(process.env.UNISWAP_CONTRACT as string,
      ethers.constants.AddressZero,
      reward_period_minutes, lock_period_minutes, reward_procents))
      .to.be.revertedWith("Contract address can not be zero");
    await expect(SuperStaking.deploy(process.env.UNISWAP_CONTRACT as string,
      superTokenAddr,
      0, lock_period_minutes, reward_procents))
      .to.be.revertedWith("Reward period can not be zero");
  });

  it("Should deploy SuperStaking contract", async function () {
    const SuperStaking = await ethers.getContractFactory("SuperStaking");
    superStaking = await SuperStaking.deploy(process.env.UNISWAP_CONTRACT as string,
      superTokenAddr, reward_period_minutes, lock_period_minutes, reward_procents);
    await superStaking.deployed();
  });

  it("Init state", async function () {
    accounts = await ethers.getSigners();
    expect(await superStaking.connect(accounts[0]).reward_period_minutes()).to.equal(reward_period_minutes);
    expect(await superStaking.connect(accounts[0]).lock_period_minutes()).to.equal(lock_period_minutes);
  });

  it("Should test reverts of stake function", async function () {
    await expect(superStaking.connect(accounts[2])
    .stake(ethers.BigNumber.from('10000000000000000000')))
    .to.be.revertedWith("Not enaught tokens");
  });

  it("Should make 1st stake with event", async function () {
    await expect(superStaking.connect(accounts[2])
    .stake(ethers.BigNumber.from('7000000000')))
    .to.emit(superStaking, "StakeDone")
    .withArgs(await accounts[2].getAddress(), ethers.BigNumber.from('7000000000'));
  });

  it("Should make second stake after 10 minutes with event", async function () {
    const t_l = 60 * 10;
    await ethers.provider.send('evm_increaseTime', [t_l]);
    await ethers.provider.send('evm_mine', []);
    await expect(superStaking.connect(accounts[2])
    .stake(ethers.BigNumber.from('8000000000')))
    .to.emit(superStaking, "StakeDone")
    .withArgs(await accounts[2].getAddress(), ethers.BigNumber.from('8000000000'));
  });

  it("Should test getStakerState()", async function () {
    let amount;
    let stake;
    let ar = await superStaking.connect(accounts[2]).getStakerState();
    amount = ar[0];
    stake = ar[1];
    expect(amount).to.equal(ethers.BigNumber.from('15000000000'));
    expect(stake[0]['amount']).to.equal(ethers.BigNumber.from('7000000000'));
    expect(stake[1]['amount']).to.equal(ethers.BigNumber.from('8000000000'));
  });

  it("Should revert claim after 20 more minutes", async function () {
    const t_l = 60 * 20 + 1;
    await ethers.provider.send('evm_increaseTime', [t_l]);
    await ethers.provider.send('evm_mine', []);
    await expect(superStaking.connect(accounts[2]).claim())
    .to.be.revertedWith("Sorry, but it is not enougth tokens on the contract");
  });

  it("Should revert claimOneStake after 20 more minutes", async function () {
    await expect(superStaking.connect(accounts[2]).claimOneStake(0))
    .to.be.revertedWith("Sorry, but it is not enougth tokens on the contract");
  });

  it("Should mint tokens from SuperToken to SuperStaking", async function () {
    superToken = await ethers.getContractAt("SuperToken",
                              process.env.SUPER_TOKEN_CONTRACT as string,
                              accounts[0]);
    await expect(superToken.mint(superStaking.address, ethers.BigNumber.from('10000000000000')))
        .to.emit(superToken, "Transfer")
        .withArgs(ethers.constants.AddressZero, superStaking.address, ethers.BigNumber.from('10000000000000'));
        const balance = await superToken.connect(accounts[1])
        .balanceOf(superStaking.address);
        expect(balance).to.equal(ethers.BigNumber.from('10000000000000'));
  });

  it("Should claim with event after 20 minutes", async function () {
    await expect(superStaking.connect(accounts[2]).claim())
    .to.emit(superStaking, "Claim")
    .withArgs(await accounts[2].getAddress(), ethers.BigNumber.from('1850000000'));
  });

  it("Should claimOneStake with event after 20 more minutes", async function () {
    const t_l = 60 * 20 + 1;
    await ethers.provider.send('evm_increaseTime', [t_l]);
    await ethers.provider.send('evm_mine', []);
    await expect(superStaking.connect(accounts[2]).claimOneStake(0))
    .to.emit(superStaking, "Claim")
    .withArgs(await accounts[2].getAddress(), ethers.BigNumber.from('700000000'));
  });

  it("Should revert unstake with invalid id of stake", async function () {
    await expect(superStaking.connect(accounts[2])
    .unstake(3, ethers.BigNumber.from('7000000000')))
    .to.be.revertedWith("Invalid ID of stake");
  });

  it("Should revert unstake because its too early now", async function () {
    await expect(superStaking.connect(accounts[2])
    .unstake(1, ethers.BigNumber.from('5000000000')))
    .to.be.revertedWith("Its not time to unstake");
  });

  it("Should revert unstake because too many tokens is requested", async function () {
    const t_l = 60 * 20 + 1;
    await ethers.provider.send('evm_increaseTime', [t_l]);
    await ethers.provider.send('evm_mine', []);
    await expect(superStaking.connect(accounts[2])
    .unstake(0, ethers.BigNumber.from('9000000000')))
    .to.be.revertedWith("Amount of tokens exceeds staked amount");
  });

  it("Should partly unstake with event 1st stake", async function () {
    await expect(superStaking.connect(accounts[2]).unstake(0, ethers.BigNumber.from('6000000000')))
    .to.emit(superStaking, "Unstake")
    .withArgs(await accounts[2].getAddress(), ethers.BigNumber.from('6000000000'));
  });

});
