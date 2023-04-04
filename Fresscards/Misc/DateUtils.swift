//
//  DateUtils.swift
//  Energram
//
//  Created by Alex Antipov on 06.03.2023.
//

import Foundation

func dateFromISOString(_ isoString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.timeZone = .gmt
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    return formatter.date(from: isoString)
    
    /// Example usage:
    /// dateFromISOString("2023-03-05T10:00:00+03:00")!
}
