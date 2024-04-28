//
//  CustomButton.swift
//  GitHubClient
//
//  Created by fox on 23/04/2024.
//

import SwiftUI

struct CustomButton {
    struct Primary: View {
        var action: (()->())
        var title: String
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .padding(.horizontal, 80)
                    .foregroundStyle(.white)
            }
            .background(.clear)
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
    }
    
    struct Secondary: View {
        var action: (()->())
        var title: String
        
        var body: some View {
            Button(action: action, label: {
                Text(title)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 92)
                    .foregroundColor(.green)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(.white)
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .stroke(.green, lineWidth: 1)
                    }
            })
        }
    }
}

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(color, lineWidth: width))
    }
}

#Preview {
    VStack {
        Spacer()
        CustomButton.Primary(action: {}, title: "RELOAD")
        CustomButton.Secondary(action: {}, title: "Quit")
        Spacer()
    }
    .background(.gray.opacity(0.3))
}

