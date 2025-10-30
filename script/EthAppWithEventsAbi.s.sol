// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {CommonBase} from "forge-std/Base.sol";
import {Script, console} from "forge-std/Script.sol";
import {IEthAppWithEvents, EthAppWithEventsAbi} from "src/EthAppWithEventsAbi.sol";
import {IMirror} from "src/IMirror.sol";
import {IRouter} from "src/IRouter.sol";
import {IWrappedVara} from "src/IWrappedVara.sol";

contract EthAppWithEventsAbiScript is CommonBase, Script {
    function setUp() public virtual {}

    function run() public virtual {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        (address routerAddress, bytes32 validatedCodeId, uint128 initialExecutableBalance, uint128 constructorBalance) =
            parseEnv();

        address mirror = deployAbi(routerAddress, validatedCodeId);
        executableBalanceTopUp(mirror, initialExecutableBalance);
        callConstructorWithValue(mirror, constructorBalance);

        vm.stopBroadcast();
    }

    function hasEnv() public view returns (bool) {
        return vm.envExists("ROUTER_ADDRESS") && vm.envExists("VALIDATED_CODE_ID")
            && vm.envExists("INITIAL_EXECUTABLE_BALANCE") && vm.envExists("CONSTRUCTOR_BALANCE");
    }

    function parseEnv()
        public
        view
        returns (
            address routerAddress,
            bytes32 validatedCodeId,
            uint128 initialExecutableBalance,
            uint128 constructorBalance
        )
    {
        routerAddress = vm.envAddress("ROUTER_ADDRESS");
        validatedCodeId = vm.envBytes32("VALIDATED_CODE_ID");
        initialExecutableBalance = uint128(vm.envUint("INITIAL_EXECUTABLE_BALANCE"));
        constructorBalance = uint128(vm.envUint("CONSTRUCTOR_BALANCE"));
    }

    function deployAbi(address routerAddress, bytes32 validatedCodeId) public returns (address) {
        return deployAbiWithInitializer(routerAddress, validatedCodeId, address(0));
    }

    function deployAbiWithInitializer(address routerAddress, bytes32 validatedCodeId, address initializer)
        public
        returns (address)
    {
        IRouter router = IRouter(routerAddress);

        EthAppWithEventsAbi ethAppWithEventsAbi = new EthAppWithEventsAbi();
        address mirror = router.createProgramWithAbiInterface(
            validatedCodeId, bytes32(vm.randomUint()), initializer, address(ethAppWithEventsAbi)
        );
        printContractInfo("EthAppWithEvents", mirror, address(ethAppWithEventsAbi));

        return mirror;
    }

    function executableBalanceTopUp(address mirror, uint128 initialExecutableBalance) public {
        address routerAddress = IMirror(mirror).router();

        IRouter router = IRouter(routerAddress);
        IWrappedVara wrappedVara = IWrappedVara(router.wrappedVara());

        if (initialExecutableBalance != 0) {
            wrappedVara.approve(mirror, initialExecutableBalance);

            IMirror(mirror).executableBalanceTopUp(initialExecutableBalance);
        }
    }

    function callConstructorWithValue(address mirror, uint128 constructorBalance) public {
        if (constructorBalance != 0) {
            IEthAppWithEvents(mirror).create{value: constructorBalance}(false);
        }
    }

    function printContractInfo(string memory contractName, address contractAddress, address expectedImplementation)
        public
        view
    {
        console.log("================================================================================================");
        console.log("[ CONTRACT  ]", contractName);
        console.log("[ ADDRESS   ]", contractAddress);
        console.log("[ ABI ADDR  ]", expectedImplementation);
        console.log(
            "[ PROXY VERIFICATION ] Click \"Is this a proxy?\" on Etherscan to be able read and write as proxy."
        );
        console.log("                       Alternatively, run the following curl request.");
        console.log("```");
        uint256 chainId = block.chainid;
        console.log("curl \\");
        console.log(string.concat("    --data \"address=", vm.toString(contractAddress), "\" \\"));
        console.log(string.concat("    --data \"expectedimplementation=", vm.toString(expectedImplementation), "\" \\"));
        console.log(
            string.concat(
                "    \"https://api.etherscan.io/v2/api?chainid=",
                vm.toString(chainId),
                "&module=contract&action=verifyproxycontract&apikey=$ETHERSCAN_API_KEY\""
            )
        );
        console.log("```");
        console.log("================================================================================================");
        console.log();
    }
}
