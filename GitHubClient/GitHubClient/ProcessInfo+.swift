//
//  ProcessInfo+.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Foundation

extension ProcessInfo {
    static var isRunningUnitTests: Bool {
        #if DEBUG
        return NSClassFromString("XCTest") != nil
        #else
        false
        #endif
    }
}
