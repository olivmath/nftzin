// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {NFTzin} from "../src/NFTzin.sol";
import {Utils} from "./Utils.t.sol";

contract BaseSetup is Utils {
    NFTzin nftzin;

    address[] _users;
    address controller;
    address alice;
    address bob;
    address eve;
    address trent;
    address zero;

    function setUp() public virtual {
        _users = createUsers(5);

        controller = _users[0];
        alice = _users[1];
        bob = _users[2];
        eve = _users[3];
        trent = _users[4];
        zero = address(0x0);

        vm.label(controller, "CONTROLLER");
        vm.label(alice, "ALICE");
        vm.label(bob, "BOB");
        vm.label(eve, "EVE");
        vm.label(trent, "TRENT");
        vm.label(zero, "ZERO");

        vm.startPrank(controller);
        nftzin = new NFTzin("");
        vm.stopPrank();
    }
}
