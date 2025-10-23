// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IEthAppWithEvents} from "./IEthAppWithEvents.sol";
import {IEthAppWithEventsCallbacks} from "./IEthAppWithEventsCallbacks.sol";

contract EthAppWithEventsCaller is IEthAppWithEventsCallbacks {
    IEthAppWithEvents public immutable VARA_ETH_PROGRAM;

    constructor(IEthAppWithEvents _varaEthProgram) payable {
        VARA_ETH_PROGRAM = _varaEthProgram;
    }

    modifier onlyVaraEthProgram() {
        _onlyVaraEthProgram();
        _;
    }

    function _onlyVaraEthProgram() internal view {
        require(msg.sender == address(VARA_ETH_PROGRAM), "Only vara.eth program can call this function");
    }

    /* call program constructor on vara.eth */

    event Initialized();

    mapping(bytes32 messageId => bool knownMessage) public createInputs;

    function create() external payable {
        bytes32 messageId = VARA_ETH_PROGRAM.create{value: msg.value}(true);
        createInputs[messageId] = true;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_create(bytes32 messageId) external onlyVaraEthProgram {
        bool knownMessage = createInputs[messageId];
        require(knownMessage, "Unknown message");

        emit Initialized();
    }

    /* compute svc1DoThis on vara.eth */

    mapping(bytes32 messageId => bytes32 inputHash) public svc1DoThisInputs;
    mapping(bytes32 inputHash => uint32 output) public svc1DoThisResults;

    function svc1DoThis(uint32 p1, string calldata p2) external {
        bytes32 messageId = VARA_ETH_PROGRAM.svc1DoThis{value: 0}(true, p1, p2);
        /// forge-lint: disable-next-line(asm-keccak256)
        bytes32 inputHash = keccak256(abi.encodePacked(p1, p2));
        svc1DoThisInputs[messageId] = inputHash;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_svc1DoThis(bytes32 messageId, uint32 r1) external onlyVaraEthProgram {
        bytes32 inputHash = svc1DoThisInputs[messageId];
        svc1DoThisResults[inputHash] = r1;
    }

    function getSvc1DoThisResult(uint32 p1, string calldata p2) public view returns (uint32) {
        /// forge-lint: disable-next-line(asm-keccak256)
        bytes32 inputHash = keccak256(abi.encodePacked(p1, p2));
        return svc1DoThisResults[inputHash];
    }

    /* compute svc1This on vara.eth */

    mapping(bytes32 messageId => bool input) public svc1ThisInputs;
    mapping(bool input => bool output) public svc1ThisResults;

    function svc1This(bool p1) external {
        bytes32 messageId = VARA_ETH_PROGRAM.svc1This{value: 0 ether}(true, p1);
        svc1ThisInputs[messageId] = p1;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_svc1This(bytes32 messageId, bool r1) external onlyVaraEthProgram {
        bool p1 = svc1ThisInputs[messageId];
        svc1ThisResults[p1] = r1;
    }

    function getSvc1ThisResult(bool p1) public view returns (bool) {
        return svc1ThisResults[p1];
    }

    /* handle vara.eth program error */

    event ErrorReply(bytes32 messageId, bytes payload, bytes4 replyCode);

    function onErrorReply(bytes32 messageId, bytes calldata payload, bytes4 replyCode) external onlyVaraEthProgram {
        emit ErrorReply(messageId, payload, replyCode);
    }
}
