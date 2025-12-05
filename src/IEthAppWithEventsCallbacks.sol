// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IEthAppWithEventsCallbacks {
    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_create(bytes32 messageId) external;

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_svc1DoThis(bytes32 messageId, uint32 r1) external;

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_svc1This(bytes32 messageId, bool r1) external;

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_svc2DoThis(bytes32 messageId, uint32 r1) external;

    function onErrorReply(bytes32 messageId, bytes calldata payload, bytes4 replyCode) external payable;
}
