// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {NFTAuth} from "./NFTzin.Auth.sol";

contract NFTCrud is NFTAuth {
    using Strings for uint256;

    constructor(string memory _baseURI) NFTAuth(_baseURI) {}

    function getMyNFTs() external view returns (uint256[] memory) {
        return myNFTs[msg.sender];
    }

    function getMyURIs() external view returns (string[] memory) {
        uint256[] memory nfts = myNFTs[msg.sender];
        string[] memory uris = new string[](nfts.length);

        if (nfts.length == 0) {
            return uris;
        }

        for (uint8 i = 0; i < nfts.length; i++) {
            uris[i] = tokenURI(nfts[i]);
        }

        return uris;
    }

    /// ERC 721

    function balanceOf(address _owner) public view virtual returns (uint256) {
        zeroAddr(_owner);
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        nftExists(tokenId);
        return _owners[tokenId];
    }

    function name() public view virtual returns (string memory) {
        return "NFTzin";
    }

    function symbol() public view virtual returns (string memory) {
        return "NFTZ";
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        nftExists(tokenId);
        if (bytes(baseURI).length > 0) {
            return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
        } else {
            return "";
        }
    }

    function approve(address to, uint256 tokenId, address auth) external {
        nftExists(tokenId);
        itsOwner(auth, tokenId);

        _tokenApprovals[tokenId] = to;
        emit Approval(auth, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        nftExists(tokenId);

        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) external {
        zeroAddr(operator);

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address _owner, address operator) external view returns (bool) {
        return _operatorApprovals[_owner][operator];
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        nftExists(tokenId);
        itsOwner(from, tokenId);
        zeroAddr(to);

        unchecked {
            _balances[from]--;
            _balances[to]++;
        }
        _tokenApprovals[tokenId] = address(0x0);
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        _transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        _transferFrom(from, to, tokenId);
        safeTransfer(to, data);
    }

    function _mint(address to, uint256 tokenId) internal {
        zeroAddr(to);

        unchecked {
            _balances[to]++;
        }

        _tokenApprovals[tokenId] = address(0x0);
        _owners[tokenId] = to;

        emit Transfer(address(0x0), to, tokenId);
    }

    function safeMint(address to, uint256 tokenId) internal {
        _mint(to, tokenId);
        safeTransfer(to, "");
    }
}
