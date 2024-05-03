//
//  ErrorAnimationView.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Lottie
import SwiftUI

struct ErrorAnimationView: View {
    var error: GitHubError = .unknown
    var retryAction: (()->())
    var cancelAction: (()->())
    
    var body: some View {
        VStack {
            LottieView(animation: .named(animation.name))
                .looping()
                .resizable()
            VStack(spacing: 30) {
                Text("Something went wrong...")
                    .foregroundColor(.white)
                    .font(.headline)
                Text(animation.message ?? "An alien is blocking your signal")
                    .foregroundColor(.white)
                    .font(.subheadline)
                CustomButton.Primary(action: retryAction, title: "RETRY")
                CustomButton.Secondary(action: cancelAction, title: "Cancel")
            }
        }
        .background(.black.opacity(0.8))
    }
    
    private var animation: (name: String, message: String?) {
        
        switch error {
        case .managedObjectContextIsMissing,
                .invalidDecode,
                .unknown:
            return ("Animation - 1714400937893",
                    nil)
        case .fourZeroFour:
            return ("Animation - 1714397911995",
                    nil)
        case .message(description: let description):
            return ("Animation - 1713576514887",
                    description)
        case .none:
            fatalError()
        }
    }
}

#Preview("message") {
    ZStack {
        RepositoriesPlaceholderView(item: RepositoryViewModel.placeholder)
        ErrorAnimationView(error: .message(description: "Some error"), retryAction: {}, cancelAction: {})
    }
}

#Preview("fourZeroFour") {
    ZStack {
        RepositoriesPlaceholderView(item: RepositoryViewModel.placeholder)
        ErrorAnimationView(error: .fourZeroFour, retryAction: {}, cancelAction: {})
    }
}

#Preview("unknown") {
    ZStack {
        RepositoriesPlaceholderView(item: RepositoryViewModel.placeholder)
        ErrorAnimationView(error: .unknown, retryAction: {}, cancelAction: {})
    }
}
