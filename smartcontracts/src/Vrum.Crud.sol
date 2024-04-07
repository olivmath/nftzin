// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {NFTAuth} from "./Vrum.Auth.sol";

contract NFTCrud is NFTAuth {
    using Strings for uint256;

    constructor(string memory _baseURI) NFTAuth(_baseURI) {}

    function myNFTs(address _owner) external view returns (uint256[] memory) {
        return _myNFTs[_owner];
    }

    function getMyURIs(address _owner) external view returns (string[] memory) {
        uint256[] memory nfts = _myNFTs[_owner];
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
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view virtual returns (address) {
        nftExists(_tokenId);
        return _owners[_tokenId];
    }

    function name() public view virtual returns (string memory) {
        return "Vrum";
    }

    function symbol() public view virtual returns (string memory) {
        return "NFTZ";
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        nftExists(_tokenId);
        return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
    }

    function approve(address to, uint256 _tokenId, address auth) external {
        nftExists(_tokenId);
        itsOwner(auth, _tokenId);

        _tokenApprovals[_tokenId] = to;
        emit Approval(auth, to, _tokenId);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        nftExists(_tokenId);

        return _tokenApprovals[_tokenId];
    }

    function setApprovalForAll(address operator, bool approved) external {
        zeroAddr(operator);

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address _owner, address operator) external view returns (bool) {
        return _operatorApprovals[_owner][operator];
    }

    function _transferFrom(address from, address to, uint256 _tokenId) internal {
        nftExists(_tokenId);
        itsOwner(from, _tokenId);
        zeroAddr(to);

        unchecked {
            _balances[from]--;
            _balances[to]++;
        }

        removeTokenIdFromList(from, _tokenId);
        _myNFTs[to].push(_tokenId);

        _tokenApprovals[_tokenId] = address(0x0);
        _owners[_tokenId] = to;
        emit Transfer(from, to, _tokenId);
    }

    function transferFrom(address from, address to, uint256 _tokenId) external {
        _transferFrom(from, to, _tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 _tokenId) external {
        safeTransferFrom(from, to, _tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 _tokenId, bytes memory data) public {
        _transferFrom(from, to, _tokenId);
        safeTransfer(to, data);
    }

    function _mint(address to, uint256 _tokenId) internal {
        zeroAddr(to);

        unchecked {
            _balances[to]++;
        }

        _tokenApprovals[_tokenId] = address(0x0);
        _myNFTs[to].push(_tokenId);
        _owners[_tokenId] = to;

        emit Transfer(address(0x0), to, _tokenId);
    }

    function safeMint(address to, uint256 _tokenId) internal {
        _mint(to, _tokenId);
        safeTransfer(to, "");
    }

    function removeTokenIdFromList(address from, uint256 _tokenId) internal {
        uint256 indexToRemove = 0;
        bool found = false;
        for (uint256 i = 0; i < _myNFTs[from].length; i++) {
            if (_myNFTs[from][i] == _tokenId) {
                indexToRemove = i;
                found = true;
                break;
            }
        }
        require(found, "TokenID not found for owner.");

        if (indexToRemove < _myNFTs[from].length - 1) {
            _myNFTs[from][indexToRemove] = _myNFTs[from][_myNFTs[from].length - 1];
        }
        _myNFTs[from].pop();
    }
}
