// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {EthAppWithEventsAbi} from "../src/EthAppWithEventsAbi.sol";

contract EthAppWithEventsAbiTest is Test {
    EthAppWithEventsAbi public ethAppWithEventsAbi;

    function setUp() public {
        ethAppWithEventsAbi = new EthAppWithEventsAbi();
    }

    function test_Create() public {
        ethAppWithEventsAbi.create(0, false);
    }
}
