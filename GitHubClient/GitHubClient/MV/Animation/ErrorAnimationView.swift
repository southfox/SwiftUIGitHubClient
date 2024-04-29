//
//  ErrorAnimationView.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Lottie
import SwiftUI

struct ErrorAnimationView: View {
    var error: GitHubError = .none
    var retryAction: (()->())
    var cancelAction: (()->())
    
    var body: some View {
        VStack {
            LottieView {
              await LottieAnimation
                .loadedFrom(url: animationUrl)
            } placeholder: {
                LottieView(animation: .named("Animation - 1713576514887"))
                    .looping()
                    .resizable()
            }
            .looping()
            .resizable()
            VStack(spacing: 30) {
                Text("Something went wrong...")
                    .foregroundColor(.white)
                    .font(.headline)
                Text("An alien is blocking your signal")
                    .foregroundColor(.white)
                    .font(.subheadline)
                CustomButton.Primary(action: retryAction, title: "RETRY")
                CustomButton.Secondary(action: cancelAction, title: "Cancel")
            }
        }
        .background(.black.opacity(0.8))
    }
    
    private var animationUrl: URL {
        URL(string: animationForError)!
    }
    
    private var animationForError: String {
        
        switch error {
        case .invalidDecode:
            return "https://lottie.host/3abf5768-5071-4e39-8fe8-0e07387d20a6/XOXSPfZiYM.json"
        case .managedObjectContextIsMissing:
            return "https://lottie.host/36837a24-79e1-47b6-97f2-b1af82bc3be6/skMMD6i8Hw.json"
        case .none:
            return "https://lottie.host/a6f594f4-43a2-47b9-9dbd-84d2dd0b32ea/Q6E2yL1gUG.json"
        }
    }
}

#Preview("none") {
    ZStack {
        Text("""
iOS Take-Home Exercise
Objective
The objective of this task is to create a straightforward, single-screen application that displays the latest trending repositories on Github, using data sourced from a public API. Detailed design and business requirements are outlined below.
The project has been designed to be accessible for all candidates, yet we are interested in observing your individual problem-solving methods. You are encouraged to fully engage with this project and showcase your capabilities for our assessment.
When tackling this assignment, please treat it as if you are developing a Minimum Viable Product (MVP) for our actual customers. Your approach to this project should mirror the practices and considerations you would employ if you were part of our team, preparing a product for market release.
"""
        )
        .padding()
        ErrorAnimationView(retryAction: {}, cancelAction: {})
    }
}

#Preview("invalidDecode") {
    ErrorAnimationView(error: .invalidDecode, retryAction: {}, cancelAction: {})
}

#Preview("managedObjectContextIsMissing") {
    ErrorAnimationView(error: .managedObjectContextIsMissing, retryAction: {}, cancelAction: {})
}
