//
//  CurrencyFormatter.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import Foundation

struct CurrencyFormatter {
    
    static func formatCurrency(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.groupingSeparator = ","
            
            if value >= 1_00_00_00_00_000 {
                let lakhCr = value / 1_00_00_00_00_000
                return String(format: "₹ %.2f L Cr", lakhCr)
            }else if value >= 10_00_00_00_000 {
                let thousandCrore = value / 10_00_00_00_000
                return String(format: "₹ %.2f K Cr", thousandCrore)
            } else if value >= 1_00_00_000 {
                let crore = value / 1_00_00_000
                return String(format: "₹ %.2f Cr", crore)
            } else if value >= 1_00_000 {
                let lakhs = value / 1_00_000
                return String(format: "₹ %.2f L", lakhs)
            } else {
                formatter.numberStyle = .currency
                formatter.currencySymbol = "₹"
                return formatter.string(from: NSNumber(value: value)) ?? "₹0.00"
            }
        }
}
