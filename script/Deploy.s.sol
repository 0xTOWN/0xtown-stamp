// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {TransparentUpgradeableProxy} from
    "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ZeroExTownStamp} from "../src/ZeroExTownStamp.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public returns (address) {
        address owner = msg.sender;
        vm.startBroadcast();
        ZeroExTownStamp impl = new ZeroExTownStamp();
        impl.initialize("", address(0));
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(impl),
            owner,
            abi.encodeWithSelector(
                ZeroExTownStamp.initialize.selector, "https://stamp.0x.town/", owner
            )
        );
        return address(proxy);
    }
}
