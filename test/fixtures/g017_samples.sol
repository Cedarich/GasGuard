// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract G017Sample {
    enum ActionState { PENDING, ACTIVE, COMPLETED, CANCELLED }

    function iterateEnum() external pure {
        for (uint8 i = 0; i < 4; i++) {
            ActionState state = ActionState(i);
        }
    }
}
