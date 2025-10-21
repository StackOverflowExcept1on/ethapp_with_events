// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {EthAppWithEventsAbiScript} from "./EthAppWithEventsAbi.s.sol";
import {IEthAppWithEvents, EthAppWithEventsCaller} from "../src/EthAppWithEventsCaller.sol";

contract EthAppWithEventsCallerScript is EthAppWithEventsAbiScript {
    function setUp() public override {}

    function run() public override {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(privateKey);
        vm.startBroadcast(privateKey);

        if (hasEnv()) {
            (
                address routerAddress,
                bytes32 validatedCodeId,
                uint128 initialExecutableBalance,
                uint128 constructorBalance
            ) = parseEnv();

            address ethAppWithEventsCallerAddress =
                vm.computeCreateAddress(deployerAddress, vm.getNonce(deployerAddress) + 2);

            address mirror = deployAbiWithInitializer(routerAddress, validatedCodeId, ethAppWithEventsCallerAddress);
            executableBalanceTopUp(mirror, initialExecutableBalance);

            EthAppWithEventsCaller ethAppWithEventsCaller = new EthAppWithEventsCaller(IEthAppWithEvents(mirror));
            transferValueToCaller(address(ethAppWithEventsCaller), constructorBalance);
            ethAppWithEventsCaller.create{value: constructorBalance}();
        } else if (vm.envExists("GEAR_EXE_PROGRAM")) {
            address gearExeProgram = vm.envAddress("GEAR_EXE_PROGRAM");

            new EthAppWithEventsCaller(IEthAppWithEvents(gearExeProgram));
        } else {
            revert();
        }

        vm.stopBroadcast();
    }
}
