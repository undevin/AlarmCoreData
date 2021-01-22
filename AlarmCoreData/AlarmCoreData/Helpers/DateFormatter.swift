//
//  DateFormatter.swift
//  AlarmCoreData
//
//  Created by Devin Flora on 1/21/21.
//

import Foundation

extension DateFormatter {
    static let alarmTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}//End of Extension
