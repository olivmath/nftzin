// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {MintPriceNotPaid, MaxSupply} from "../src/NFTzin.sol";

contract NFTzinTest is BaseSetup {
    using stdStorage for StdStorage;

    function setUp() public override {
        BaseSetup.setUp();
    }

    function test_RevertMintWithoutValue() public {
        vm.expectRevert(MintPriceNotPaid.selector);
        nftzin.mintTo(address(1));
    }

    function test_MintPricePaid() public {
        nftzin.mintTo{value: 0.00008 ether}(address(1));
    }

    function test_RevertMintMaxSupplyReached() public {
        uint256 slot = stdstore.target(address(nftzin)).sig("currentTokenId()").find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(100));
        vm.store(address(nftzin), loc, mockedCurrentTokenId);
        vm.expectRevert(MaxSupply.selector);
        nftzin.mintTo{value: 0.08 ether}(address(1));
    }

    function test_RevertMintToZeroAddress() public {
        vm.expectRevert("INVALID_RECIPIENT");
        nftzin.mintTo{value: 0.08 ether}(address(0));
    }

    function test_NewMintOwnerRegistered() public {
        nftzin.mintTo{value: 0.08 ether}(address(1));
        uint256 slotOfNewOwner =
            stdstore.target(address(nftzin)).sig(nftzin.ownerOf.selector).with_key(address(1)).find();

        uint160 ownerOfTokenIdOne = uint160(uint256((vm.load(address(nftzin), bytes32(abi.encode(slotOfNewOwner))))));
        assertEq(address(ownerOfTokenIdOne), address(1));
    }

    function test_BalanceIncremented() public {
        nftzin.mintTo{value: 0.08 ether}(address(1));
        uint256 slotBalance =
            stdstore.target(address(nftzin)).sig(nftzin.balanceOf.selector).with_key(address(1)).find();

        uint256 balanceFirstMint = uint256(vm.load(address(nftzin), bytes32(slotBalance)));
        assertEq(balanceFirstMint, 1);

        nftzin.mintTo{value: 0.08 ether}(address(1));
        uint256 balanceSecondMint = uint256(vm.load(address(nftzin), bytes32(slotBalance)));
        assertEq(balanceSecondMint, 2);
    }

    function test_getUri() public {
        nftzin.mintTo{value: 0.00008 ether}(address(1));
        string memory baseuri = "https://ipfs.io/ipfs/QmVaM1FwbsDuwfaRiYVYFL9iAcP1pFMaoE2tyTHf8k8Seo/1.png";
        assertEq(nftzin.tokenURI(1), baseuri);
    }
    
    function test_getNFTS() public {
        nftzin.mintTo{value: 0.00008 ether}(address(1));
        nftzin.mintTo{value: 0.00008 ether}(address(1));
        nftzin.mintTo{value: 0.00008 ether}(address(1));
        nftzin.mintTo{value: 0.00008 ether}(address(1));
        assertEq(nftzin.getMyNFTs().length, 2);
    }
}
