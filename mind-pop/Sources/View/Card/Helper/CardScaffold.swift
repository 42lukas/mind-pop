//
//  CardScaffold.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct CardScaffold<Content: View>: View {
    let category: String
    let avatarURL: URL?
    let content: () -> Content

    init(category: String, avatarURL: URL? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.category = category
        self.avatarURL = avatarURL
        self.content = content
    }

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            HStack(alignment: .bottom) {
                VStack {
                    Spacer(minLength: 0)

                    content()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.94))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.accentColor.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 8)
                        )
                        .padding(.leading)

                    Spacer(minLength: 0)
                }

                SideRail(category: category, avatarURL: avatarURL)
                    .padding(.bottom, 60)
                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    CardScaffold(category: "Science") {
        Text("Beispielinhalt")
            .font(.title)
    }
}
