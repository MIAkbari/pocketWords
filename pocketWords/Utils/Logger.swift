//
//  Logger.swift
//  pocketWords
//
//  Created by Mohammad on 5/13/25.
//

import OSLog

extension Logger {
    static let busSystem = Bundle.main.bundleIdentifier ?? .init()
    static var os = Logger(subsystem: busSystem, category: "statices")
}
