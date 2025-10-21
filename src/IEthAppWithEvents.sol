// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IEthAppWithEvents {
    event DoThisEvent(uint32 indexed p1, string p2);

    // TODO: should it generate `payable` functions?

    function create(bool encodeReply) external payable returns (bytes32 messageId);

    function svc1DoThis(bool encodeReply, uint32 p1, string calldata p2) external payable returns (bytes32 messageId);

    function svc1This(bool encodeReply, bool p1) external payable returns (bytes32 messageId);
}
