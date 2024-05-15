# Uniswap V2 Flash Loan Project

This project demonstrates how to perform flash loans using Uniswap V2, leveraging the capabilities of Ethereum smart contracts. It includes a custom implementation of the Uniswap V2 Library, a flash loaner contract (`UniswapFlashloaner.sol`), and utilities for interacting with Uniswap V1 and V2, as well as handling ERC20 tokens and WETH.

## Features

- Perform flash loans through Uniswap V2.
- Interact with Uniswap V1 and V2 for swapping tokens.
- Utilize WETH (Wrapped Ether) for transactions involving Ether.
- Implement safe mathematical operations using the SafeMath library.

## Getting Started

### Prerequisites

Ensure you have Node.js installed on your system. If not, download and install it from [Node.js](https://nodejs.org/en/download/).

Install Hardhat, a development environment for compiling, deploying, testing, and debugging Ethereum software. Run:

```bash
npm install --save-dev hardhat
```

### Installation

Clone the repository:

```bash
git clone https://github.com/Patrick-Ehimen/uniswapV2-flashLoan.git
cd uniswapV2-flashSwap
```

Install dependencies:

```bash
npm install
```

### Usage

Deploy the `UniswapFlashloaner` contract:

```javascript
// deploy_UniswapFlashloaner.js
const UniswapFlashloanerFactory = await ethers.getContractFactory(
  "UniswapFlashloaner"
);
const uniFlashloaner = await UniswapFlashloanerFactory.deploy(...getAddrs());
console.log(`UniswapFlashloaner contract deployed to:`, uniFlashloaner.address);
```

Perform a flash loan:

```javascript
// flashloan_test.js
let pair_res = await UniswapV2Pair.swap(
  0,
  1,
  flashloanerAddress.uniswapFlashloanerAddress,
  ethers.utils.arrayify("0x00"),
  OVERRIDES
);
await pair_res.wait();
console.log(
  `Uniswap V2 flashSwap successfully, please check tx hash ${pair_res.hash} for more details`
);
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
