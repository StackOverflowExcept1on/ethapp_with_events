// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IEthAppWithEvents {
    event DoThisEvent(uint32 indexed p1, string p2);

    function create(uint128 value, bool encodeReply) external returns (bytes32 messageId);

    function svc1DoThis(uint128 value, bool encodeReply, uint32 p1, string calldata p2)
        external
        returns (bytes32 messageId);

    function svc1This(uint128 value, bool encodeReply, bool p1) external returns (bytes32 messageId);
}
