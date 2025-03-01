// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Factory} from "../src/Factory.sol";
import {Implementation} from "../src/Implementation.sol";
contract FactoryScript is Script {
    Factory public factory;

    function setUp() public {}

    function run() public { 
        vm.startBroadcast();

        Implementation implementation = new Implementation(address(this));
        factory = new Factory(address(implementation));

        vm.stopBroadcast();
    }
}
