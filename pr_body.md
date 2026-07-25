## Summary

This pull request introduces the **Soroban Low-Level Memory Layout Analyzer** (`WasmInspector`) in `packages/rules/soroban/src/analyzer/`. It examines compiled Soroban WebAssembly (`.wasm`) bytecode binaries to pinpoint unoptimized linear memory allocations, static data segment bloat, host import call frequencies, dynamic memory growth (`memory.grow`), stack frame allocation bloat, and unaligned memory accesses. Findings are correlated back to source Rust file line numbers and function symbols.

## What Changed

- **`packages/rules/soroban/src/analyzer/wasm-inspector.ts`**:
  - **`WasmParser`**: Decodes WebAssembly binary headers, LEB128 unsigned/signed variable-length integers, and sections (Type, Import, Function, Memory, Global, Export, Code, Data, and Custom sections including symbol `name` section and source path references).
  - **`WasmInspector`**:
    - **Linear Memory Allocation Bloat**: Detects initial memory page declarations exceeding baseline thresholds (default > 1 page / 64KB).
    - **Static Data Segment Bloat**: Identifies static data segments totaling excessive bytes in memory (default > 4KB).
    - **Host Import Call Frequency**: Maps and tallies host environment calls per function body, flagging functions with high call frequencies (> 5 calls/func).
    - **Dynamic Memory Growth (`memory.grow`)**: Identifies opcode `0x40` (`memory.grow`) calls which introduce runtime penalties in Soroban.
    - **Stack Frame & Alignment Analysis**: Detects large stack frame adjustments on `__stack_pointer` (> 1024 bytes) and unaligned memory loads/stores.
    - **Source Line Correlation**: Maps instruction offsets back to Rust source file locations (`src/contract.rs:42:10`) and function names.
- **`packages/rules/soroban/src/analyzer/wasm-inspector.spec.ts`**:
  - Automated unit test suite with 7 test cases verifying WASM parsing, header validation, memory bloat detection, static data bloat, host import call frequency, `memory.grow` detection, and source location mapping.
- **`packages/rules/soroban/src/index.ts`**:
  - Re-exported `WasmInspector` and related types from the Soroban rules package.

## Why

High-level Rust abstractions often hide inefficient memory operations and allocation overheads that are only visible at the compiled WASM bytecode level. This analyzer allows GasGuard to inspect Soroban contract binary outputs directly and pinpoint exact source line locations for developer optimizations.

## Testing Performed

- [x] Added 7 new unit tests in `wasm-inspector.spec.ts` (100% passing rate).
- [x] Verified full test suite for `packages/rules/soroban` (10/10 tests passing).
- [x] Validated edge case handling for invalid WASM headers, missing debug sections, and custom host imports.

## Edge Cases Considered

- Invalid or corrupted WASM magic headers / version headers.
- Binaries with zero memories or zero static data segments.
- Modules compiled without DWARF debug sections (graceful fallback to `name` section demangling or function indices).
- Variable-length LEB128 encoding variations for signed/unsigned integers.
- Unaligned memory loads and stores across various WASM types (`i32.load`, `i64.load`, etc.).

## Risks

None. This is a non-breaking additive addition in `packages/rules/soroban/src/analyzer/`.

Closes #605
