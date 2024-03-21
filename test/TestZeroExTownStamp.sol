// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {ZeroExTownStamp} from "../src/ZeroExTownStamp.sol";

contract TestZeroExTownStamp is Test {
    function testMint() external {
        ZeroExTownStamp town = new ZeroExTownStamp();
        town.initialize("https://stamp.0x.town/", address(this));
        town.setMintAllowed(true);
        address u1 = vm.addr(1024);
        vm.prank(u1);
        vm.warp(1000000);
        town.mint();
        address u2 = vm.addr(1025);
        vm.prank(u2);
        vm.warp(2000000);
        town.mint();
        console2.log(town.tokenURI(1));
        console2.log(town.tokenURI(2));

        town.setTransferAllowed(true);
        vm.prank(u2);
        town.transferFrom(u2, address(this), 2);
    }
}
