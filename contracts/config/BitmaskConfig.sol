// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BitmaskConfig {
    error Unauthorized();
    error InvalidBitOffset();

    address public immutable owner;

    uint256 public constant PAUSED_BIT = 1 << 0;
    uint256 public constant LOCKED_BIT = 1 << 1;
    uint256 public constant ALLOW_PUBLIC_BIT = 1 << 2;
    uint256 public constant FEE_SWITCH_BIT = 1 << 3;
    uint256 public constant EMERGENCY_STOP_BIT = 1 << 4;
    uint256 public constant UPGRADEABLE_BIT = 1 << 5;

    bytes32 private _flags;

    event FlagSet(uint256 indexed bit, bool value);
    event FlagToggled(uint256 indexed bit);

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    constructor(address owner_, bool[6] memory initialFlags) {
        owner = owner_;
        bytes32 flags;
        if (initialFlags[0]) flags |= bytes32(PAUSED_BIT);
        if (initialFlags[1]) flags |= bytes32(LOCKED_BIT);
        if (initialFlags[2]) flags |= bytes32(ALLOW_PUBLIC_BIT);
        if (initialFlags[3]) flags |= bytes32(FEE_SWITCH_BIT);
        if (initialFlags[4]) flags |= bytes32(EMERGENCY_STOP_BIT);
        if (initialFlags[5]) flags |= bytes32(UPGRADEABLE_BIT);
        _flags = flags;
    }

    function isSet(uint256 bit) external view returns (bool) {
        uint256 result;
        assembly {
            let f := sload(_flags.slot)
            result := and(f, bit)
        }
        return result != 0;
    }

    function setFlag(uint256 bit, bool value) external onlyOwner {
        if (bit > UPGRADEABLE_BIT) revert InvalidBitOffset();
        assembly {
            let f := sload(_flags.slot)
            switch value
            case 1 { f := or(f, bit) }
            default { f := and(f, not(bit)) }
            sstore(_flags.slot, f)
        }
        emit FlagSet(bit, value);
    }

    function toggleFlag(uint256 bit) external onlyOwner {
        if (bit > UPGRADEABLE_BIT) revert InvalidBitOffset();
        assembly {
            let f := sload(_flags.slot)
            f := xor(f, bit)
            sstore(_flags.slot, f)
        }
        emit FlagToggled(bit);
    }

    function getFlags() external view returns (bool[6] memory) {
        bytes32 f = _flags;
        bool[6] memory result;
        result[0] = (f & bytes32(PAUSED_BIT)) != 0;
        result[1] = (f & bytes32(LOCKED_BIT)) != 0;
        result[2] = (f & bytes32(ALLOW_PUBLIC_BIT)) != 0;
        result[3] = (f & bytes32(FEE_SWITCH_BIT)) != 0;
        result[4] = (f & bytes32(EMERGENCY_STOP_BIT)) != 0;
        result[5] = (f & bytes32(UPGRADEABLE_BIT)) != 0;
        return result;
    }
}
