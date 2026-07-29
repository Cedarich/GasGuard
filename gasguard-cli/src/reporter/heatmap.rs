//! Terminal Color-Coded Gas Consumption Heatmap Output

pub struct GasHeatmapReporter {
    pub no_color: bool,
}

impl GasHeatmapReporter {
    pub fn new(no_color: bool) -> Self {
        Self { no_color }
    }

    pub fn format_gas_tier(&self, function_name: &str, gas_cost: u64) -> String {
        if self.no_color {
            return format!("[{}] {} - {} gas", self.get_tier_label(gas_cost), function_name, gas_cost);
        }

        let color_code = match gas_cost {
            0..=4999 => "\x1b[32m",    // Green (Low)
            5000..=25000 => "\x1b[33m", // Yellow (Medium)
            _ => "\x1b[31m",           // Red (High)
        };
        let reset = "\x1b[0m";

        format!("{}{}[{}] {} - {} gas{}", color_code, "", self.get_tier_label(gas_cost), function_name, gas_cost, reset)
    }

    fn get_tier_label(&self, gas_cost: u64) -> &'static str {
        match gas_cost {
            0..=4999 => "LOW",
            5000..=25000 => "MEDIUM",
            _ => "HIGH",
        }
    }
}
