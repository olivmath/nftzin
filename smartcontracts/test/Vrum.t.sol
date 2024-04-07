// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {NFTErrors} from "../src/Vrum.Errors.sol";

contract VrumTest is BaseSetup {
    using stdStorage for StdStorage;

    function setUp() public override {
        BaseSetup.setUp();
    }

    function test_RevertMintWithoutValue() public {
        vm.prank(bob);
        vm.expectRevert(NFTErrors.InsufficientAmount.selector);
        vrum.mintToMe();
    }

    function test_SimpleMint() public {
        vm.prank(bob);
        vrum.mintToMe{value: 0.00008 ether}();
        assertEq(vrum.balanceOf(bob), 1);
    }

    function test_RevertMintMaxSupplyReached() public {
        uint256 slot = stdstore.target(address(vrum)).sig(vrum.tokenId.selector).find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(100));

        vm.store(address(vrum), loc, mockedCurrentTokenId);
        vm.expectRevert(NFTErrors.MaxSupply.selector);
        vrum.mintToMe{value: 0.08 ether}();
    }

    function test_RevertMintToZeroAddress() public {
        vm.deal(address(zero), 1 ether);

        vm.expectRevert(NFTErrors.ZeroAddress.selector);
        vm.prank(zero);
        vrum.mintToMe{value: 0.08 ether}();
    }

    function test_NewMintOwnerRegistered() public {
        vm.prank(alice);
        vrum.mintToMe{value: 0.08 ether}();
        uint256 tokenId = 1;
        assertEq(vrum.ownerOf(tokenId), alice);

        // uint256 slotOfNewOwner = stdstore.target(address(vrum)).sig(vrum.ownerOf.selector).with_key(bytes32(tokenId)).find();
        // uint160 ownerOfTokenIdOne = uint160(
        //     uint256(
        //         (vm.load(address(vrum), bytes32(abi.encode(slotOfNewOwner))))
        //     )
        // );
        // assertEq(address(ownerOfTokenIdOne), alice);
    }

    function test_BalanceIncremented() public {
        vm.prank(bob);
        vrum.mintToMe{value: 0.08 ether}();
        uint256 slotBalance = stdstore.target(address(vrum)).sig(vrum.balanceOf.selector).with_key(bob).find();

        uint256 balanceFirstMint = uint256(vm.load(address(vrum), bytes32(slotBalance)));
        assertEq(balanceFirstMint, 1);
        assertEq(vrum.balanceOf(bob), 1);

        vm.prank(bob);
        vrum.mintToMe{value: 0.08 ether}();
        uint256 balanceSecondMint = uint256(vm.load(address(vrum), bytes32(slotBalance)));
        assertEq(balanceSecondMint, 2);
    }

    function test_getNFTS() public {
        vm.startPrank(bob);
        vrum.mintToMe{value: 0.00008 ether}();
        vrum.mintToMe{value: 0.00008 ether}();
        vrum.mintToMe{value: 0.00008 ether}();
        vrum.mintToMe{value: 0.00008 ether}();
        vm.stopPrank();

        uint256[] memory bobsNfts = vrum.myNFTs(bob);
        assertEq(bobsNfts.length, 4);
        assertEq(bobsNfts[0], 1);
        assertEq(bobsNfts[1], 2);
        assertEq(bobsNfts[2], 3);
        assertEq(bobsNfts[3], 4);
    }

    function test_TransferNFTFromBobToAlice() public {
        vm.startPrank(bob);
        vrum.mintToMe{value: 0.08 ether}();
        vrum.mintToMe{value: 0.08 ether}();
        vrum.mintToMe{value: 0.08 ether}();
        vrum.mintToMe{value: 0.08 ether}();
        vm.stopPrank();

        uint256 bobInitialBalance = vrum.balanceOf(bob);
        uint256 aliceInitialBalance = vrum.balanceOf(alice);

        uint256 tokenIdToTransfer = 3;

        vm.prank(bob);
        vrum.transferFrom(bob, alice, tokenIdToTransfer);


        uint256 bobFinalBalance = vrum.balanceOf(bob);
        uint256 aliceFinalBalance = vrum.balanceOf(alice);

        assertEq(bobFinalBalance, bobInitialBalance - 1);
        assertEq(aliceFinalBalance, aliceInitialBalance + 1);

        uint256[] memory bobsNFTs = vrum.myNFTs(bob);
        assertEq(bobsNFTs.length, 3);
        assertEq(bobsNFTs[0], 1);
        assertEq(bobsNFTs[1], 2);
        assertEq(bobsNFTs[2], 4);

        string[] memory bobsUri = vrum.getMyURIs(bob);
        assertEq(bobsUri.length, 3);

        uint256[] memory alicesNFTs = vrum.myNFTs(alice);
        assertEq(alicesNFTs.length, 1);
        string[] memory alicesUri = vrum.getMyURIs(alice);
        assertEq(alicesUri.length, 1);

        assertEq(vrum.ownerOf(tokenIdToTransfer), alice);
    }
}
