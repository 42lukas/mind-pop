//
//  TrueFalseCard.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct TrueFalseCard: View {
    let category: String
    let statement: String
    let isTrue: Bool
    let explanation: String?
    let avatarURL: URL? = URL(string: "https://picsum.photos/201")

    @State private var answered = false
    @State private var wasCorrect = false

    var body: some View {
        CardScaffold(category: category, avatarURL: avatarURL) {
            Text(statement)
                .font(.title2).bold()
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: 14) {
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        answered = true; wasCorrect = (isTrue == false)
                    }
                } label: {
                    Text("Falsch").bold()
                        .foregroundStyle(Color.textPrimary)
                        .frame(maxWidth: .infinity).padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(answered ? (isTrue ? Color.red.opacity(0.18) : Color.green.opacity(0.22)) : Color.brandGray.opacity(0.35))
                        )
                }
                .buttonStyle(.plain)

                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        answered = true; wasCorrect = (isTrue == true)
                    }
                } label: {
                    Text("Wahr").bold()
                        .foregroundStyle(Color.textPrimary)
                        .frame(maxWidth: .infinity).padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(answered ? (isTrue ? Color.green.opacity(0.22) : Color.red.opacity(0.18)) : Color.brandGray.opacity(0.35))
                        )
                }
                .buttonStyle(.plain)
            }

            if answered {
                Text(wasCorrect ? "Richtig ✅" : "Falsch ❌")
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
                if let explanation {
                    Text(explanation)
                        .font(.subheadline)
                        .foregroundStyle(Color.textPrimary.opacity(0.7))
                }
            }
        }
    }
}

#Preview("True/False – New") {
    TrueFalseCard(
        category: "History",
        statement: "Die Berliner Mauer fiel 1989.",
        isTrue: true,
        explanation: "Am 9. November 1989."
    )
    .frame(height: 700)
}
