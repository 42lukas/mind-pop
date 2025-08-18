//
//  OrderCard.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct OrderCard: View {
    let category: String
    let prompt: String
    let items: [String]
    let correctOrderIndices: [Int]
    let explanation: String?
    let avatarURL: URL? = URL(string: "https://picsum.photos/202")

    var onDraggingChanged: ((Bool) -> Void)? = nil

    @State private var working: [RowItem] = []
    @State private var locked = false
    @State private var isCorrect = false
    @State private var isDragging = false { didSet { onDraggingChanged?(isDragging) } }

    var body: some View {
        CardScaffold(category: category, avatarURL: avatarURL) {
            Text(prompt)
                .font(.title2).bold()
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            ReorderableVStack(items: $working) { item, dragging in
                HStack(spacing: 12) {
                    Text(item.title)
                        .foregroundStyle(Color.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                }
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.brandGray.opacity(0.35))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(dragging ? Color.accent.opacity(0.5) : Color.brandNavy.opacity(0.10), lineWidth: 1)
                )
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { _ in if !isDragging { isDragging = true } }
                    .onEnded { _ in isDragging = false }
            )

            Button {
                withAnimation {
                    locked = true
                    isCorrect = evaluate()
                }
            } label: {
                Text("Antwort prüfen").bold()
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity).padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.brandGray.opacity(0.35))
                    )
            }
            .disabled(locked)

            if locked {
                Text(isCorrect ? "Richtig ✅" : "Falsch ❌")
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
                if let explanation {
                    Text(explanation)
                        .font(.subheadline)
                        .foregroundStyle(Color.textPrimary.opacity(0.7))
                }
            }
        }
        .onAppear {
            if working.isEmpty {
                let base = items.enumerated().map { RowItem(id: UUID(), title: $0.element, originalIndex: $0.offset) }
                working = base.shuffled()
            }
        }
    }

    private func evaluate() -> Bool {
        working.map { $0.originalIndex } == correctOrderIndices
    }

    struct RowItem: Identifiable, Equatable {
        let id: UUID
        let title: String
        let originalIndex: Int
    }
}

#Preview("Order – New") {
    OrderCard(
        category: "History",
        prompt: "Bringe die Ereignisse in korrekte Reihenfolge (alt → neu).",
        items: ["Französische Revolution", "Erster Weltkrieg", "Mondlandung"],
        correctOrderIndices: [0, 1, 2],
        explanation: "1789 → 1914–1918 → 1969."
    )
    .frame(height: 700)
}
