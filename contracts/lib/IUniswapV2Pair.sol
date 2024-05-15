// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IUniswapV2Pair {
    /// @notice Emitted when an approval is given
    /// @param owner The address of the owner
    /// @param spender The address of the spender
    /// @param value The amount approved to be spent
    event Approval(address indexed owner, address indexed spender, uint value);

    /// @notice Emitted when a transfer occurs
    /// @param from The address of the sender
    /// @param to The address of the receiver
    /// @param value The amount transferred
    event Transfer(address indexed from, address indexed to, uint value);

    /// @notice Gets the name of the token
    /// @return The name of the token as a string
    function name() external pure returns (string memory);

    /// @notice Gets the symbol of the token
    /// @return The symbol of the token as a string
    function symbol() external pure returns (string memory);

    /// @notice Gets the number of decimals used
    /// @return The number of decimals as an unsigned integer
    function decimals() external pure returns (uint8);

    /// @notice Gets the total supply of the token
    /// @return The total supply as an unsigned integer
    function totalSupply() external view returns (uint);

    /// @notice Gets the balance of a specified address
    /// @param owner The address to query the balance of
    /// @return The balance as an unsigned integer
    function balanceOf(address owner) external view returns (uint);

    /// @notice Gets the amount which the spender is still allowed to spend
    /// @param owner The address which owns the funds
    /// @param spender The address which will spend the funds
    /// @return The remaining amount as an unsigned integer
    function allowance(address owner, address spender) external view returns (uint);

    /// @notice Approves the passed address to spend the specified amount of tokens
    /// @param spender The address which will spend the funds
    /// @param value The amount of tokens to be spent
    /// @return True if the operation was successful
    function approve(address spender, uint value) external returns (bool);

    /// @notice Transfers tokens to a specified address
    /// @param to The address to transfer to
    /// @param value The amount to be transferred
    /// @return True if the operation was successful
    function transfer(address to, uint value) external returns (bool);

    /// @notice Transfers tokens from one address to another
    /// @param from The address to transfer from
    /// @param to The address to transfer to
    /// @param value The amount to be transferred
    /// @return True if the operation was successful
    function transferFrom(address from, address to, uint value) external returns (bool);

    /// @notice Gets the domain separator used in signatures
    /// @return The domain separator as a bytes32 value
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /// @notice Gets the permit type hash used in signatures
    /// @return The permit type hash as a bytes32 value
    function PERMIT_TYPEHASH() external pure returns (bytes32);

    /// @notice Gets the current nonce for an owner address
    /// @param owner The address to query the nonce for
    /// @return The current nonce as an unsigned integer
    function nonces(address owner) external view returns (uint);

    /// @notice Sets approval from owner to spender via off-chain signatures
    /// @param owner The address which owns the funds
    /// @param spender The address which will spend the funds
    /// @param value The amount to be approved
    /// @param deadline The time at which the approval expires
    /// @param v The recovery byte of the signature
    /// @param r Half of the ECDSA signature pair
    /// @param s Half of the ECDSA signature pair
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    /// @notice Emitted when tokens are minted
    /// @param sender The address which triggered the mint
    /// @param amount0 The amount of token0 minted
    /// @param amount1 The amount of token1 minted
    event Mint(address indexed sender, uint amount0, uint amount1);

    /// @notice Emitted when tokens are burned
    /// @param sender The address which triggered the burn
    /// @param amount0 The amount of token0 burned
    /// @param amount1 The amount of token1 burned
    /// @param to The address which will receive the funds
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    /// @notice Emitted when a swap occurs
    /// @param sender The address which triggered the swap
    /// @param amount0In The amount of token0 inputted
    /// @param amount1In The amount of token1 inputted
    /// @param amount0Out The amount of token0 outputted
    /// @param amount1Out The amount of token1 outputted
    /// @param to The address which will receive the swap funds
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );

    /// @notice Emitted to synchronize the reserves
    /// @param reserve0 The reserve of token0
    /// @param reserve1 The reserve of token1
    event Sync(uint112 reserve0, uint112 reserve1);

    /// @notice Gets the minimum liquidity value
    /// @return The minimum liquidity as an unsigned integer
    function MINIMUM_LIQUIDITY() external pure returns (uint);

    /// @notice Gets the address of the factory contract
    /// @return The factory address
    function factory() external view returns (address);

    /// @notice Gets the address of token0
    /// @return The token0 address
    function token0() external view returns (address);

    /// @notice Gets the address of token1
    /// @return The token1 address
    function token1() external view returns (address);

    /// @notice Gets the current reserves of both tokens
    /// @return reserve0 The current reserve of token0 as an unsigned integer
    /// @return reserve1 The current reserve of token1 as an unsigned integer
    /// @return blockTimestampLast The last block timestamp
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    /// @notice Gets the last cumulative price of token0
    /// @return The last cumulative price of token0 as an unsigned integer
    function price0CumulativeLast() external view returns (uint);

    /// @notice Gets the last cumulative price of token1
    /// @return The last cumulative price of token1 as an unsigned integer
    function price1CumulativeLast() external view returns (uint);

    /// @notice Gets the last k value
    /// @return The last k value as an unsigned integer
    function kLast() external view returns (uint);

    /// @notice Mints liquidity tokens to a specified address
    /// @param to The address to mint to
    /// @return liquidity The amount of liquidity tokens minted
    function mint(address to) external returns (uint liquidity);

    /// @notice Burns liquidity tokens from a specified address
    /// @param to The address to burn from
    /// @return amount0 The amount of token0 burned
    /// @return amount1 The amount of token1 burned
    function burn(address to) external returns (uint amount0, uint amount1);

    /// @notice Swaps tokens
    /// @param amount0Out The amount of token0 to output
    /// @param amount1Out The amount of token1 to output
    /// @param to The address to send the output to
    /// @param data The data to be passed to the recipient
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    /// @notice Skims the token balance to a specified address
    /// @param to The address to skim to
    function skim(address to) external;

    /// @notice Syncs the contract state with the reserves
    function sync() external;

    /// @notice Initializes the contract with specified addresses
    /// @param , The initial address
    /// @param , The initial address
    function initialize(address, address) external;
}