// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract G016Sample {
    function redundantCast(address addr) external pure returns (address) {
        return address(payable(addr));
    }
}
