//
//  SingleChoiceCard.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct SingleChoiceCard: View {
    let category: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String?
    let avatarURL: URL? = URL(string: "https://picsum.photos/200")

    @State private var selected: Int? = nil
    @State private var locked = false

    var body: some View {
        CardScaffold(category: category, avatarURL: avatarURL) {
            Text(prompt)
                .font(.title2).bold()
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            VStack {
                ForEach(options.indices, id: \.self) { i in
                    Button {
                        guard !locked else { return }
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                            selected = i; locked = true
                        }
                    } label: {
                        HStack {
                            Text(options[i]).foregroundStyle(Color.textPrimary)
                            Spacer()
                            if locked && i == correctIndex { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                            if locked && i == selected && i != correctIndex { Image(systemName: "xmark.circle.fill").foregroundStyle(.red) }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(locked ? (i == correctIndex ? Color.green.opacity(0.2) : (i == selected ? Color.red.opacity(0.18) : Color.brandGray.opacity(0.3))) : Color.brandGray.opacity(0.35)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.brandNavy.opacity(0.1), lineWidth: 1))
                    }
                }
            }

            if locked {
                Text(selected == correctIndex ? "Richtig" : "Falsch").font(.headline).foregroundStyle(Color.textPrimary)
                if let explanation { Text(explanation).font(.subheadline).foregroundStyle(Color.textPrimary.opacity(0.7)) }
            }
        }
    }
}

#Preview("SingleChoice – New") {
    SingleChoiceCard(
        category: "Science",
        prompt: "Welches Element hat das chemische Symbol O?",
        options: ["Gold", "Sauerstoff", "Silber", "Wasserstoff"],
        correctIndex: 1,
        explanation: "O steht für Sauerstoff."
    )
    .frame(height: 700)
}
