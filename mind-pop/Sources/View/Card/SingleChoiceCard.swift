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

    @State private var selected: Int? = nil
    @State private var locked = false

    var body: some View {
        VStack(spacing: 16) {
            Header(category: category)
            Text(prompt).font(.title3).bold().multilineTextAlignment(.center).padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(options.indices, id: \.self) { i in
                    Button {
                        guard !locked else { return }
                        selected = i
                        locked = true
                    } label: {
                        HStack {
                            Text(options[i]).multilineTextAlignment(.leading)
                            Spacer()
                            if locked && i == correctIndex { Image(systemName: "checkmark.circle.fill") }
                            if locked && i == selected && i != correctIndex { Image(systemName: "xmark.circle.fill") }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(bgColor(i)))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

            if locked {
                Text(selected == correctIndex ? "Richtig ✅" : "Falsch ❌")
                    .font(.headline)
                if let explanation { Text(explanation).font(.subheadline).foregroundStyle(.secondary).padding(.horizontal) }
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 32)
        .background(Color(.systemBackground))
    }

    private func bgColor(_ i: Int) -> Color {
        guard locked else { return Color(.secondarySystemBackground) }
        if i == correctIndex { return Color.green.opacity(0.25) }
        if i == selected { return Color.red.opacity(0.25) }
        return Color(.secondarySystemBackground)
    }
}
