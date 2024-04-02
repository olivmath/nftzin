// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract NFTErrors {
    error NonexistentToken(uint256 tokenId);
    error InsufficientAmount();
    error InsecureReceiver();
    error Unauthorized();
    error NoReentrancy();
    error ZeroAddress();
    error MaxSupply();
}
