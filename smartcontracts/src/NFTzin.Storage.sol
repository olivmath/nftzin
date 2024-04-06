// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {NFTEvents} from "./NFTzin.Events.sol";
import {NFTErrors} from "./NFTzin.Errors.sol";

contract NFTStorage is NFTEvents, NFTErrors {
    uint256 public constant MINT_PRICE = 0.00008 ether;
    uint256 public constant TOTAL_SUPPLY = 100;
    uint256 public tokenId;
    string public baseURI;

    bool internal locked;
    address internal owner;

    mapping(address owner => mapping(address operator => bool)) internal _operatorApprovals;
    mapping(uint256 tokenId => address) internal _tokenApprovals;
    mapping(uint256 tokenId => address) internal _owners;
    mapping(address owner => uint256) internal _balances;
    mapping(address => uint256[]) internal _myNFTs;

    constructor(string memory _baseURI) {
        baseURI = _baseURI;
        owner = msg.sender;
    }
}
