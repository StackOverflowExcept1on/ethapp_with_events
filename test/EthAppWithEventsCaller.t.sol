// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {EthAppWithEventsAbi} from "../src/EthAppWithEventsAbi.sol";
import {EthAppWithEventsCaller} from "../src/EthAppWithEventsCaller.sol";

contract EthAppWithEventsCallerTest is Test {
    EthAppWithEventsCaller public ethAppWithEventsCaller;

    function setUp() public {
        ethAppWithEventsCaller = new EthAppWithEventsCaller(new EthAppWithEventsAbi());
    }

    function test_Create() public {
        ethAppWithEventsCaller.create(0);
    }
}
