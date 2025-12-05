// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IEthAppWithEvents {
    event DoThisEvent(uint32 indexed p1, string p2);

    function create(bool callReply) external returns (bytes32 messageId);

    function svc1DoThis(bool callReply, uint32 p1, string calldata p2) external returns (bytes32 messageId);

    function svc1This(bool callReply, bool p1) external returns (bytes32 messageId);

    function svc2DoThis(bool callReply, uint32 p1, string calldata p2) external returns (bytes32 messageId);
}
