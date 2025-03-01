// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory {
    event MyEvent(address indexed proxy, uint256 value);

    // The implementation contract address that proxies will delegate to
    address public immutable implementation;
    uint256 public saltCounter;

    constructor(address _implementation) {
        require(_implementation != address(0), "Invalid implementation");
        implementation = _implementation;
    }

    function deployProxy() external returns (address proxy) {
        // create a salt
        bytes32 salt = keccak256(abi.encodePacked(saltCounter));
        // deploy a proxy with immutable args using create2
        proxy = Clones.cloneDeterministicWithImmutableArgs(implementation, abi.encode(salt), salt);
        saltCounter++;
    }

    function emitEvent(uint256 value, bytes32 salt) external {
        address computedAddress = predictProxyAddress(abi.encode(salt), salt);
        require(msg.sender == computedAddress, "Only valid proxies can emit events");
        emit MyEvent(computedAddress, value);
    }

    function predictProxyAddress(bytes memory args, bytes32 salt) public view returns (address) {
        return Clones.predictDeterministicAddressWithImmutableArgs(implementation, args, salt);
    }
}
