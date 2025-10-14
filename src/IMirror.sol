// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IMirror {
    function router() external view returns (address);

    function executableBalanceTopUp(uint128 value) external;
}
