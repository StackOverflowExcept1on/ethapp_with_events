// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IEthAppWithEventsCallbacks {
    function replyOn_create(bytes32 messageId) external;

    function replyOn_svc1DoThis(bytes32 messageId, uint32 r1) external;

    function replyOn_svc1This(bytes32 messageId, bool r1) external;

    function onErrorReply(bytes32 messageId, bytes calldata payload, bytes4 replyCode) external;
}
