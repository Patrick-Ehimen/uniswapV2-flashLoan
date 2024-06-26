// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './lib/UniswapV2Library.sol';

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

interface IUniswapV1Exchange {
    function balanceOf(address owner) external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function removeLiquidity(
        uint256,
        uint256,
        uint256,
        uint256
    ) external returns (uint256, uint256);

    function tokenToEthSwapInput(
        uint256,
        uint256,
        uint256
    ) external returns (uint256);

    function ethToTokenSwapInput(uint256, uint256) external payable returns (uint256);
}

interface IUniswapV1Factory {
    function getExchange(address) external view returns (address);
}

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}

contract UniswapFlashloaner is IUniswapV2Callee {
    IUniswapV1Factory immutable factoryV1;
    address immutable factory;
    IWETH immutable WETH; // weth

    /**
     * @notice Constructor initializes the flash loan contract with Uniswap factories and WETH address.
     * @param _factory The address of the Uniswap V2 factory.
     * @param _factoryV1 The address of the Uniswap V1 factory.
     * @param router The address of the WETH contract / router.
     */
    constructor(
        address _factory,
        address _factoryV1,
        address router
    ) public {
        factory = _factory;
        factoryV1 = IUniswapV1Factory(_factoryV1);
        // WETH = IWETH(WETHAddr);
        WETH = IWETH(router);
    }

    /**
     * @notice Function to receive Ether. `msg.data` must be empty.
     */
    receive() external payable {}

    /**
     * @notice Executes a flash swap on Uniswap V2, swaps tokens/WETH on Uniswap V1, repays V2, and keeps profit.
     * @param amount0 The amount of token0 received in the flash swap.
     * @param amount1 The amount of token1 received in the flash swap.
     */
    function uniswapV2Call(
        uint256 amount0,
        uint256 amount1
    ) external {
        address[] memory path = new address[](2);
        uint256 amountToken;
        uint256 amountETH;

        {
            // scope for token{0,1}, avoids stack too deep errors
            address token0 = IUniswapV2Pair(msg.sender).token0();
            address token1 = IUniswapV2Pair(msg.sender).token1();
            assert(msg.sender == UniswapV2Library.pairFor(factory, token0, token1)); // ensure that msg.sender is actually a V2 pair
            assert(amount0 == 0 || amount1 == 0); // this strategy is unidirectional
            path[0] = amount0 == 0 ? token0 : token1;
            path[1] = amount0 == 0 ? token1 : token0;
            amountToken = token0 == address(WETH) ? amount1 : amount0;
            amountETH = token0 == address(WETH) ? amount0 : amount1;
        }

        assert(path[0] == address(WETH) || path[1] == address(WETH)); // this strategy only works with a V2 WETH pair
        IERC20 token = IERC20(path[0] == address(WETH) ? path[1] : path[0]);

        // do actions here
        if (amountToken > 0) {
            token.transfer(msg.sender, amountToken); // return tokens to V2 pair
        } else {
            WETH.transfer(msg.sender, amountETH); // return WETH to V2 pair
        }
    }
}