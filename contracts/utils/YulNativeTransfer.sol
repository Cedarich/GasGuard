// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title YulNativeTransfer
/// @notice Gas-optimized native asset transfer avoiding `.call{value: x}("")` overhead.
library YulNativeTransfer {
    error NativeTransferFailed(address recipient);

    /// @notice Sends `amount` wei to `recipient` using a zero-memory-footprint call.
    function safeTransferETH(address recipient, uint256 amount) internal {
        bool success;
        assembly {
            success := call(gas(), recipient, amount, 0, 0, 0, 0)
        }
        if (!success) revert NativeTransferFailed(recipient);
    }
}
