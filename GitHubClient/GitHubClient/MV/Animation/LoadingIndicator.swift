//
//  LoadingIndicator.swift
//  GitHubClient
//
//  Created by fox on 29/04/2024.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        Image(systemName: "rays")
            .rotationEffect(animating ? Angle.degrees(360) : .zero)
            .animation(
                Animation
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false),
                value: animating)
            .onAppear {
                animating = true
            }
    }
}

#Preview {
    LoadingIndicator()
}
