// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {

    /// @notice Adds two unsigned integers
    /// @param x The first integer
    /// @param y The second integer
    /// @return z The sum of x and y
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    /// @notice Subtracts the second unsigned integer from the first
    /// @param x The first integer
    /// @param y The second integer
    /// @return z The difference of x and y
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    /// @notice Multiplies two unsigned integers
    /// @param x The first integer
    /// @param y The second integer
    /// @return z The product of x and y
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}