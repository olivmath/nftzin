// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {NFTHelper} from "./NFTzin.Helper.sol";

contract NFTzin is NFTHelper {
    constructor(string memory _baseURI) NFTHelper(_baseURI) {}

    function mintToMe() public payable {
        zeroAddr(msg.sender);
        validateAmount();
        incrementSupply();

        safeMint(msg.sender, tokenId);
    }

    function withdraw() external {
        onlyOwner();

        (bool ok, bytes memory data) = payable(msg.sender).call{value: address(this).balance}("");
        if (!ok) {
            assembly {
                let initData := 32
                revert(add(data, initData), mload(data))
            }
        }
    }
}
