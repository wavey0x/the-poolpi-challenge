// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory {
    event MyEvent(uint256 indexed value);

    // The implementation contract address that proxies will delegate to
    address public immutable implementation;
    uint256 public saltCounter;

    constructor(address _implementation) {
        require(_implementation != address(0), "Invalid implementation");
        implementation = _implementation;
    }

    /**
     * @dev Deploys a new proxy instance using CREATE2
     * @param salt The salt value used for CREATE2 and passed as immutable to the proxy
     * @return proxy The address of the deployed proxy
     */
    function deployProxy() external returns (address proxy) {
        // Deploy a new minimal proxy with deterministic address

        proxy = Clones.cloneDeterministic(implementation, keccak256(bytes32(saltCounter)));
        (bool success, ) = proxy.call(abi.encodeWithSignature("setSalt(bytes32)", salt));
        require(success, "Initialization failed");
        saltCounter++;
    }

    function emitEvent(uint256 value, bytes32 salt) external {
        address computedAddress = predictProxyAddress(salt);
        require(msg.sender == computedAddress, "Only valid proxies can emit events");
        emit MyEvent(value);
    }



    /**
     * @dev Computes the address where a proxy would be deployed using CREATE2
     * @param salt The salt to be used in the deployment
     * @return The predicted address
     */
    function predictProxyAddress(bytes32 salt) public view returns (address) {
        return Clones.predictDeterministicAddress(implementation, salt);
    }
}
