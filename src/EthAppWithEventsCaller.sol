// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {IEthAppWithEvents} from "./IEthAppWithEvents.sol";
import {IEthAppWithEventsCallbacks} from "./IEthAppWithEventsCallbacks.sol";
import {IMirror} from "./IMirror.sol";
import {IRouter} from "./IRouter.sol";
import {IWrappedVara} from "./IWrappedVara.sol";

contract EthAppWithEventsCaller is IEthAppWithEventsCallbacks {
    IEthAppWithEvents public immutable gearExeProgram;

    constructor(IEthAppWithEvents _gearExeProgram) {
        gearExeProgram = _gearExeProgram;
    }

    modifier onlyGearExeProgram() {
        require(msg.sender == address(gearExeProgram), "Only Gear.exe program can call this function");
        _;
    }

    /* call program constructor on Gear.exe */

    event Initialized();

    mapping(bytes32 messageId => bool knownMessage) public createInputs;

    function create(uint128 value) external {
        if (value != 0) {
            IMirror mirror = IMirror(address(gearExeProgram));
            IRouter router = IRouter(mirror.router());
            IWrappedVara wrappedVara = IWrappedVara(router.wrappedVara());

            wrappedVara.approve(address(gearExeProgram), value);
        }

        bytes32 messageId = gearExeProgram.create(value, true);
        createInputs[messageId] = true;
    }

    function replyOn_create(bytes32 messageId) external onlyGearExeProgram {
        bool knownMessage = createInputs[messageId];
        require(knownMessage, "Unknown message");

        emit Initialized();
    }

    /* compute svc1DoThis on Gear.exe */

    mapping(bytes32 messageId => bytes32 inputHash) public svc1DoThisInputs;
    mapping(bytes32 inputHash => uint32 output) public svc1DoThisResults;

    function svc1DoThis(uint32 p1, string calldata p2) external {
        bytes32 messageId = gearExeProgram.svc1DoThis(0, true, p1, p2);
        bytes32 inputHash = keccak256(abi.encodePacked(p1, p2));
        svc1DoThisInputs[messageId] = inputHash;
    }

    function replyOn_svc1DoThis(bytes32 messageId, uint32 r1) external onlyGearExeProgram {
        bytes32 inputHash = svc1DoThisInputs[messageId];
        svc1DoThisResults[inputHash] = r1;
    }

    function getSvc1DoThisResult(uint32 p1, string calldata p2) public view returns (uint32) {
        bytes32 inputHash = keccak256(abi.encodePacked(p1, p2));
        return svc1DoThisResults[inputHash];
    }

    /* compute svc1This on Gear.exe */

    mapping(bytes32 messageId => bool input) public svc1ThisInputs;
    mapping(bool input => bool output) public svc1ThisResults;

    function svc1This(bool p1) external {
        bytes32 messageId = gearExeProgram.svc1This(0, true, p1);
        svc1ThisInputs[messageId] = p1;
    }

    function replyOn_svc1This(bytes32 messageId, bool r1) external onlyGearExeProgram {
        bool p1 = svc1ThisInputs[messageId];
        svc1ThisResults[p1] = r1;
    }

    function getSvc1ThisResult(bool p1) public view returns (bool) {
        return svc1ThisResults[p1];
    }

    /* handle Gear.exe program error */

    event ErrorReply(bytes32 messageId, bytes payload, bytes4 replyCode);

    function onErrorReply(bytes32 messageId, bytes calldata payload, bytes4 replyCode) external onlyGearExeProgram {
        emit ErrorReply(messageId, payload, replyCode);
    }
}
