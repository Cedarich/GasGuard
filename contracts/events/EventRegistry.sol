// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EventRegistry
 * @notice Refactors runtime keccak256 event signature hashing to compile-time constant topic selectors.
 */
contract EventRegistry {
    // Pre-computed compile-time constant event topics
    bytes32 public constant EVENT_TRANSFER_TOPIC = keccak256("Transfer(address,address,uint256)");
    bytes32 public constant EVENT_APPROVAL_TOPIC = keccak256("Approval(address,address,uint256)");

    event LogRegistered(bytes32 indexed topic, address indexed emitter);

    function logEvent(address emitter) external {
        emit LogRegistered(EVENT_TRANSFER_TOPIC, emitter);
    }
}
