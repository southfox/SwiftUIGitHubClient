//
//  ErrorAnimationView.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import Lottie
import SwiftUI

struct ErrorAnimationView: View {
    var retryAction: (()->())
    var cancelAction: (()->())
    
    var body: some View {
        VStack {
            LottieView(animation: .named("Animation - 1713576514887"))
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
}

#Preview {
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
