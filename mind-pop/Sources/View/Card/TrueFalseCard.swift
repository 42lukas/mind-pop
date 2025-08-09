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

    @State private var answered: Bool = false
    @State private var wasCorrect: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Header(category: category)
            Text(statement).font(.title3).bold().multilineTextAlignment(.center).padding(.horizontal)

            HStack(spacing: 16) {
                Button {
                    answered = true; wasCorrect = (isTrue == false)
                } label: {
                    Text("Falsch")
                        .frame(maxWidth: .infinity).padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(answered ? (isTrue ? Color.red.opacity(0.25) : Color.green.opacity(0.25)) : Color(.secondarySystemBackground)))
                }
                .buttonStyle(.plain)

                Button {
                    answered = true; wasCorrect = (isTrue == true)
                } label: {
                    Text("Wahr")
                        .frame(maxWidth: .infinity).padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(answered ? (isTrue ? Color.green.opacity(0.25) : Color.red.opacity(0.25)) : Color(.secondarySystemBackground)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)

            if answered {
                Text(wasCorrect ? "Richtig ✅" : "Falsch ❌").font(.headline)
                if let explanation { Text(explanation).font(.subheadline).foregroundStyle(.secondary).padding(.horizontal) }
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 32)
        .background(Color(.systemBackground))
    }
}
