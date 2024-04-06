// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {NFTCrud} from "./Vrum.Crud.sol";

contract NFTHelper is NFTCrud {
    constructor(string memory _baseURI) NFTCrud(_baseURI) {}
}
