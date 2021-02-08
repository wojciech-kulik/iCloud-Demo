//
//  Formatter.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 08/02/2021.
//

import Foundation

extension Formatter {
    static let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
}
