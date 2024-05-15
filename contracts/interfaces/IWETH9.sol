// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IWETH9 {
    /**
     * @notice Deposit ether and receive wrapped Ether (WETH)
     */
    function deposit() external payable;

    /**
     * @notice Withdraw WETH and receive ether
     * @param wad The amount of WETH to withdraw
     */
    function withdraw(uint wad) external;

    /**
     * @notice Get the total supply of WETH
     * @return The total supply of WETH
     */
    function totalSupply() external view returns (uint);

    /**
     * @notice Approve another address to spend a specified amount of WETH on behalf of the caller
     * @param guy The address which is approved to spend the WETH
     * @param wad The amount of WETH to be approved for spending
     * @return True if the approval was successful, otherwise false
     */
    function approve(address guy, uint wad) external returns (bool);

    /**
     * @notice Transfer WETH from the caller's address to another address
     * @param dst The address to transfer WETH to
     * @param wad The amount of WETH to transfer
     * @return True if the transfer was successful, otherwise false
     */
    function transfer(address dst, uint wad) external returns (bool);

    /**
     * @notice Transfer WETH from one address to another address
     * @param src The address to transfer WETH from
     * @param dst The address to transfer WETH to
     * @param wad The amount of WETH to transfer
     * @return True if the transfer was successful, otherwise false
     */
    function transferFrom(address src, address dst, uint wad) external returns (bool);

}