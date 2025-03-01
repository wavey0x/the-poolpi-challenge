pragma solidity 0.8.28;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

interface IFactory {
    function emitEvent(uint256 value, bytes32 salt) external;
}

contract Implementation {
    IFactory public immutable factory;

    constructor(address _factory) {
        factory = IFactory(_factory);
    }

    function doSomething(uint256 value) external {
        bytes memory args = Clones.fetchCloneArgs(address(this));
        // decode the args to get the salt that was used to deploy the proxy
        IFactory(factory).emitEvent(value, abi.decode(args, (bytes32)));
    }
}