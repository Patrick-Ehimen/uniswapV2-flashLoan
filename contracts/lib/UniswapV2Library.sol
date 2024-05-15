// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './IUniswapV2Pair.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

library UniswapV2Library {
    using SafeMath for uint256;

    /**
     * @notice Returns sorted token addresses
     * @dev Used to handle return values from pairs sorted in this order
     * @param tokenA Address of the first token
     * @param tokenB Address of the second token
     * @return token0 Address of the first sorted token
     * @return token1 Address of the second sorted token
     */
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    /**
     * @notice Calculates the CREATE2 address for a pair without making any external calls
     * @param factory Address of the Uniswap factory
     * @param tokenA Address of the first token
     * @param tokenB Address of the second token
     * @return pair Address of the calculated pair
     */
    function pairFor(
        address factory,
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex'ff',
                            factory,
                            keccak256(abi.encodePacked(token0, token1)),
                            hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
                        )
                    )
                )
            )
        );
    }

    /**
     * @notice Calculates the CREATE2 address for a pair without making any external calls (public method)
     * @param factory Address of the Uniswap factory
     * @param tokenA Address of the first token
     * @param tokenB Address of the second token
     * @return pair Address of the calculated pair
     */
    function getPair(
        address factory,
        address tokenA,
        address tokenB
    ) public pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex'ff',
                            factory,
                            keccak256(abi.encodePacked(token0, token1)),
                            hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
                        )
                    )
                )
            )
        );
    }

    /**
     * @notice Fetches and sorts the reserves for a pair
     * @param factory Address of the Uniswap factory
     * @param tokenA Address of the first token
     * @param tokenB Address of the second token
     * @return reserveA Amount of reserves for tokenA
     * @return reserveB Amount of reserves for tokenB
     */
    function getReserves(
        address factory,
        address tokenA,
        address tokenB
    ) internal view returns (uint256 reserveA, uint256 reserveB) {
        (address token0, ) = sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    /**
     * @notice Given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
     * @param amountA Amount of the first asset
     * @param reserveA Amount of reserves for the first asset
     * @param reserveB Amount of reserves for the second asset
     * @return amountB Equivalent amount of the second asset
     */
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    /**
     * @notice Given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
     * @param amountIn Input amount of the first asset
     * @param reserveIn Amount of reserves for the input asset
     * @param reserveOut Amount of reserves for the output asset
     * @return amountOut Maximum output amount of the other asset
     */
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint256 amountInWithFee = amountIn.mul(997);
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    /**
     * @notice Given an output amount of an asset and pair reserves, returns a required input amount of the other asset
     * @param amountOut Output amount of the first asset
     * @param reserveIn Amount of reserves for the input asset
     * @param reserveOut Amount of reserves for the output asset
     * @return amountIn Required input amount of the other asset
     */
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint256 numerator = reserveIn.mul(amountOut).mul(1000);
        uint256 denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    /**
     * @notice Performs chained getAmountOut calculations on any number of pairs
     * @param factory Address of the Uniswap factory
     * @param amountIn Input amount of the first asset
     * @param path Array of token addresses
     * @return amounts Array containing amounts of output assets for each pair in the path
     */
    function getAmountsOut(
        address factory,
        uint256 amountIn,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    /**
     * @notice Performs chained getAmountIn calculations on any number of pairs
     * @param factory Address of the Uniswap factory
     * @param amountOut Output amount of the last asset in path
     * @param path Array of token addresses
     * @return amounts Array containing amounts of input assets required for each pair in the path
     */
    function getAmountsIn(
        address factory,
        uint256 amountOut,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint256[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint256 i = path.length - 1; i > 0; i--) {
            (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}