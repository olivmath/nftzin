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

    function test_SimpleMint() public {
        vm.prank(bob);
        nftzin.mintToMe{value: 0.00008 ether}();
        assertEq(nftzin.balanceOf(bob), 1);
    }

    function test_RevertMintMaxSupplyReached() public {
        uint256 slot = stdstore.target(address(nftzin)).sig(nftzin.tokenId.selector).find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(100));

        vm.store(address(nftzin), loc, mockedCurrentTokenId);
        vm.expectRevert(NFTErrors.MaxSupply.selector);
        nftzin.mintToMe{value: 0.08 ether}();
    }

    function test_RevertMintToZeroAddress() public {
        vm.deal(address(zero), 1 ether);

        vm.expectRevert(NFTErrors.ZeroAddress.selector);
        vm.prank(zero);
        nftzin.mintToMe{value: 0.08 ether}();
    }

    function test_NewMintOwnerRegistered() public {
        vm.prank(alice);
        nftzin.mintToMe{value: 0.08 ether}();
        uint256 tokenId = 1;
        assertEq(nftzin.ownerOf(tokenId), alice);

        // uint256 slotOfNewOwner = stdstore.target(address(nftzin)).sig(nftzin.ownerOf.selector).with_key(bytes32(tokenId)).find();
        // uint160 ownerOfTokenIdOne = uint160(
        //     uint256(
        //         (vm.load(address(nftzin), bytes32(abi.encode(slotOfNewOwner))))
        //     )
        // );
        // assertEq(address(ownerOfTokenIdOne), alice);
    }

    function test_BalanceIncremented() public {
        vm.prank(bob);
        nftzin.mintToMe{value: 0.08 ether}();
        uint256 slotBalance = stdstore.target(address(nftzin)).sig(nftzin.balanceOf.selector).with_key(bob).find();

        uint256 balanceFirstMint = uint256(vm.load(address(nftzin), bytes32(slotBalance)));
        assertEq(balanceFirstMint, 1);
        assertEq(nftzin.balanceOf(bob), 1);

        vm.prank(bob);
        nftzin.mintToMe{value: 0.08 ether}();
        uint256 balanceSecondMint = uint256(vm.load(address(nftzin), bytes32(slotBalance)));
        assertEq(balanceSecondMint, 2);
    }

    function test_getNFTS() public {
        vm.startPrank(bob);
        nftzin.mintToMe{value: 0.00008 ether}();
        nftzin.mintToMe{value: 0.00008 ether}();
        nftzin.mintToMe{value: 0.00008 ether}();
        nftzin.mintToMe{value: 0.00008 ether}();
        vm.stopPrank();

        uint256[] memory bobsNfts = nftzin.myNFTs(bob);
        assertEq(bobsNfts.length, 4);
        assertEq(bobsNfts[0], 1);
        assertEq(bobsNfts[1], 2);
        assertEq(bobsNfts[2], 3);
        assertEq(bobsNfts[3], 4);
    }
}
