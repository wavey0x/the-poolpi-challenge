// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Factory} from "../src/Factory.sol";
import {Implementation} from "../src/Implementation.sol";

contract FactoryTest is Test {
    Factory public factory;
    Implementation public implementation;

    event MyEvent(address indexed proxy, uint256 value);

    function setUp() public {
        address factoryAddress = computeCreateAddress(address(this), vm.getNonce(address(this))+1);
        implementation = new Implementation(factoryAddress);
        console.log("implementation", address(implementation));
        factory = new Factory(address(implementation));
    }
    
    function test_DeployProxy() public {
        Implementation proxy = Implementation(factory.deployProxy());
        vm.expectEmit(address(factory));
        emit MyEvent(address(proxy), 1);
        proxy.doSomething(1);
    }

    function test_CannotCallFromProxyWithWrongSalt() public {
        uint256 saltCounter = 0;
        Implementation proxy = Implementation(factory.deployProxy());

        // Using correct salt: should succeed
        vm.prank(address(proxy));
        factory.emitEvent(1, keccak256(abi.encodePacked(saltCounter)));
        // Using correct salt: should succeed
        proxy.doSomething(1);

        uint256 wrongSalt = 69420;
        vm.prank(address(proxy));
        vm.expectRevert("Only valid proxies can emit events");
        // Using wrong salt: should revert
        factory.emitEvent(1, keccak256(abi.encodePacked(wrongSalt)));
    }
}
