// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IRouter {
    function wrappedVara() external view returns (address);

    function createProgramWithAbiInterface(
        bytes32 codeId,
        bytes32 salt,
        address overrideInitializer,
        address abiInterface
    ) external returns (address mirror);
}
