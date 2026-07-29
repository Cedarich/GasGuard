//! Rule G017: Flag Unbounded Iteration Over Enum Types in Solidity loops.

pub struct RuleG017EnumIteration;

impl RuleG017EnumIteration {
    pub fn name() -> &'static str {
        "G017_enum_iteration"
    }

    pub fn check(source_code: &str) -> Vec<String> {
        let mut warnings = Vec::new();
        if source_code.contains("for (") || source_code.contains("while (") {
            if source_code.contains("enum ") || source_code.contains("Enum") {
                warnings.push("Warning: Unbounded iteration over enum type detected".to_string());
            }
        }
        warnings
    }
}
