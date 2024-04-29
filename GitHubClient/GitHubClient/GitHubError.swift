//
//  GitHubError.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import Foundation

enum GitHubError: Error {
    case managedObjectContextIsMissing
    case invalidDecode
    case none
}
