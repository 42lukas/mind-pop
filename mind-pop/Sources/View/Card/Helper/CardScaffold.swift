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
    
    private let railWidth: CGFloat = 84
    
    init(category: String, avatarURL: URL? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.category = category
        self.avatarURL = avatarURL
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    content()
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.brandWhite.opacity(0.94))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 8)
                )
            }.frame(width: 350)
            
            SideRail(category: category, avatarURL: avatarURL)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    CardScaffold(category: "Science", avatarURL: URL(string: "https://picsum.photos/200")) {
        Text("Welches Element hat das chemische Symbol O?")
            .font(.title3).bold()
            .foregroundStyle(Color.textPrimary)
        
        VStack(spacing: 12) {
            ForEach(["Wasserstoff", "Sauerstoff", "Kohlenstoff"], id: \.self) { answer in
                Text(answer)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.brandGray.opacity(0.3)))
            }
        }
    }
}
