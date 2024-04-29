//
//  GitHubError.swift
//  GitHubClient
//
//  Created by fox on 20/04/2024.
//

import Foundation

enum GitHubError: Error, Equatable {
    case invalidDecode
    case managedObjectContextIsMissing
    case message(description: String)
    case unknown
    case fourZeroFour
    case none
    
    static func == (lhs: GitHubError, rhs: GitHubError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

extension Error {
    var githubError: GitHubError {
        if (self as NSError).code == 404 {
            return .fourZeroFour
        }
        return .message(description: localizedDescription)
    }
}
