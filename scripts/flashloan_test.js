const { expect } = require("chai");
const { hasRegexChars } = require("prettier");
const { ethers } = require("hardhat");
require("dotenv").config();
const { getTokenAddress } = require("../utils/index");
const flashloanerAddress = require("../UniswapFlashloaner.json");

async function main() {
  let [wallet] = await ethers.getSigners();

  // kovan uniswap v2 factory address
  const factory = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
  let getTokenAddr = getTokenAddress("kovan");

  const artifactUniswapV2Library =
    artifacts.readArtifactSync("UniswapV2Library");
  let iuniswapV2Library = new ethers.Contract(
    flashloanerAddress.uniswapV2LibraryAddress,
    artifactUniswapV2Library.abi,
    wallet
  );
  let pairAddr = await iuniswapV2Library.getPair(
    factory,
    getTokenAddr("WETH"),
    getTokenAddr("DAI")
  );
  console.log(pairAddr);

  const artifactIUniswapV2Pair = artifacts.readArtifactSync("IUniswapV2Pair");
  let UniswapV2Pair = new ethers.Contract(
    pairAddr,
    artifactIUniswapV2Pair.abi,
    wallet
  );

  const OVERRIDES = {
    gasLimit: 8e6,
    gasPrice: 60e8,
  };

  console.log("Going to do Uniswap V2 flashSwap");
  const bytes = ethers.utils.arrayify("0x00");
  let pair_res = await UniswapV2Pair.swap(
    0,
    1,
    flashloanerAddress.uniswapFlashloanerAddress,
    bytes,
    OVERRIDES
  );

  await pair_res.wait();
  console.log(
    `Uniswap V2 flashSwap successfully, please check tx hash ${pair_res.hash} for more details `
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
