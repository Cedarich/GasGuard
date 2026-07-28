// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CodeCheckLib
/// @notice Gas-optimized contract existence check using raw `extcodesize`.
library CodeCheckLib {
    /// @notice Returns true if `target` has deployed code.
    /// @dev Skips the stack management overhead of high-level `.code.length`.
    function isContract(address target) internal view returns (bool result) {
        assembly {
            result := gt(extcodesize(target), 0)
        }
    }
}
