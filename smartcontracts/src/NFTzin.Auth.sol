// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import {NFTStorage} from "./NFTzin.Storage.sol";

contract NFTAuth is NFTStorage {
    constructor(string memory _baseURI) NFTStorage(_baseURI) {}

    modifier nonReentrant() {
        if (locked) {
            revert NoReentrancy();
        }

        locked = true;
        _;
        locked = false;
    }

    function zeroAddr(address addr) internal pure {
        if (addr == address(0x0)) {
            revert ZeroAddress();
        }
    }

    function onlyOwner() internal view {
        zeroAddr(msg.sender);
        if (msg.sender != owner) {
            revert Unauthorized();
        }
    }

    function validateAmount() internal view {
        if (msg.value < MINT_PRICE) {
            revert InsufficientAmount();
        }
    }

    function incrementSupply() internal {
        uint256 newTokenId = currentNFTId + 1;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        currentNFTId = newTokenId;
    }

    function nftExists(uint256 tokenId) internal view {
        address _owner = _owners[tokenId];
        if (_owner == address(0)) {
            revert NonexistentToken(tokenId);
        }
    }

    function itsOwner(address auth, uint256 tokenId) internal view {
        address _owner = _owners[tokenId];
        if (_owner != auth) {
            revert Unauthorized();
        }
    }

    function itsAllowed(address caller, uint256 tokenId) internal view {
        bool a = _operatorApprovals[msg.sender][caller];
        bool b = caller == _tokenApprovals[tokenId];

        if (a || b) {
            revert Unauthorized();
        }
    }

    function safeTransfer(address to, bytes memory data) internal view {
        uint256 size = to.code.length;
        bytes4 selector = ERC721TokenReceiver(to).onERC721Received(address(0x0), address(0x0), 0, data);

        if (size > 0 && selector != ERC721TokenReceiver.onERC721Received.selector) {
            revert InsecureReceiver();
        }
    }
}

abstract contract ERC721TokenReceiver {
    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}
