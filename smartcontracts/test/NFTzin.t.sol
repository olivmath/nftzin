// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {NFTErrors} from "../src/NFTzin.Errors.sol";

contract NFTzinTest is BaseSetup {
    using stdStorage for StdStorage;

    function setUp() public override {
        BaseSetup.setUp();
    }

    function test_RevertMintWithoutValue() public {
        vm.prank(bob);
        vm.expectRevert(NFTErrors.InsufficientAmount.selector);
        nftzin.mintToMe();
    }

    function test_MintPricePaid() public {
        vm.prank(bob);
        nftzin.mintToMe{value: 0.00008 ether}();
    }

    function test_RevertMintMaxSupplyReached() public {
        uint256 slot = stdstore.target(address(nftzin)).sig("currentTokenId()").find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(100));
        vm.store(address(nftzin), loc, mockedCurrentTokenId);
        vm.expectRevert(NFTErrors.MaxSupply.selector);
        nftzin.mintToMe{value: 0.08 ether}();
    }

    function test_RevertMintToZeroAddress() public {
        vm.expectRevert("INVALID_RECIPIENT");
        vm.prank(zero);
        nftzin.mintToMe{value: 0.08 ether}();
    }

    function test_NewMintOwnerRegistered() public {
        vm.prank(alice);
        nftzin.mintToMe{value: 0.08 ether}();
        uint256 tokenId = 1;
        uint256 slotOfNewOwner = stdstore.target(address(nftzin)).sig(nftzin.ownerOf.selector).with_key(tokenId).find();
        bytes32 loc = bytes32(abi.encode(slotOfNewOwner));

        uint160 ownerOfTokenIdOne = uint160(uint256((vm.load(address(nftzin), loc))));
        assertEq(address(ownerOfTokenIdOne), alice);
    }

    function test_BalanceIncremented() public {
        vm.prank(bob);
        nftzin.mintToMe{value: 0.08 ether}();
        uint256 nftAmount = 1;
        uint256 slotBalance = stdstore.target(address(nftzin)).sig(nftzin.balanceOf.selector).with_key(nftAmount).find();

        uint256 balanceFirstMint = uint256(vm.load(address(nftzin), bytes32(slotBalance)));
        assertEq(balanceFirstMint, 1);

        vm.prank(bob);
        nftzin.mintToMe{value: 0.08 ether}();
        uint256 balanceSecondMint = uint256(vm.load(address(nftzin), bytes32(slotBalance)));
        assertEq(balanceSecondMint, 2);
    }

    function test_getUri() public {
        vm.prank(bob);
        nftzin.mintToMe{value: 0.00008 ether}();
        string memory baseuri = "https://ipfs.io/ipfs/random/1.png";
        assertEq(nftzin.tokenURI(1), baseuri);
    }

    function test_getNFTS() public {
        nftzin.mintToMe{value: 0.00008 ether}();
        nftzin.mintToMe{value: 0.00008 ether}();
        nftzin.mintToMe{value: 0.00008 ether}();
        nftzin.mintToMe{value: 0.00008 ether}();
        assertEq(nftzin.getMyNFTs().length, 4);
    }
}
