//! Rule G016: Flag Redundant address(uint160(x)) Cast Operations in Solidity AST.

pub struct RuleG016RedundantCasts;

impl RuleG016RedundantCasts {
    pub fn name() -> &'static str {
        "G016_redundant_casts"
    }

    pub fn check(source_code: &str) -> Vec<String> {
        let mut warnings = Vec::new();
        if source_code.contains("address(uint160(") || source_code.contains("address(payable(") {
            warnings.push("Warning: Redundant address cast operation detected".to_string());
        }
        warnings
    }
}
