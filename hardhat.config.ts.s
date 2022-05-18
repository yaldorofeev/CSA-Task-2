import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";


dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  // solidity: "0.5.16",
  solidity: {
    compilers: [
        { version: "0.8.0" },
      ],
  },
  // defaultNetwork: "rinkeby",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts:
        process.env.PRIVATE_KEY_OWNER !== undefined ? [process.env.PRIVATE_KEY_OWNER, process.env.PRIVATE_KEY_BAYER_1, process.env.PRIVATE_KEY_BAYER_2, process.env.PRIVATE_KEY_BAYER_3] : [],
    },
    hardhat: {
      forking: {
              url: process.env.RINKEBY_URL || '',
              blockNumber: 10670230 // some block number
          },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  // external: {
  //   contracts: [
  //     {
  //       artifacts: 'node_modules/@uniswap/v2-core/build',
  //     },
  //     {
  //       artifacts: 'node_modules/@uniswap/v2-periphery/build',
  //     },
  //   ],
  // },
};

export default config;
