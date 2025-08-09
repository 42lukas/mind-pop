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

    @State private var working: [String] = []
    @State private var locked = false
    @State private var isCorrect = false

    var body: some View {
        VStack(spacing: 16) {
            Header(category: category)
            Text(prompt).font(.title3).bold().multilineTextAlignment(.center).padding(.horizontal)

            // Reorderbare Liste (funktioniert in iOS 17 gut)
            List {
                ForEach(working, id: \.self) { s in
                    Text(s).padding(.vertical, 8)
                }
                .onMove { indices, newOffset in
                    working.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .environment(\.editMode, .constant(.active)) // Drag Gripper anzeigen
            .frame(maxHeight: 360)
            .listStyle(.plain)

            Button {
                locked = true
                isCorrect = evaluate()
            } label: {
                Text("Antwort prüfen").bold()
                    .frame(maxWidth: .infinity).padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                    .padding(.horizontal)
            }
            .disabled(locked)

            if locked {
                Text(isCorrect ? "Richtig ✅" : "Falsch ❌").font(.headline)
                if let explanation { Text(explanation).font(.subheadline).foregroundStyle(.secondary).padding(.horizontal) }
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 32)
        .onAppear {
            // Shuffle zum Start
            if working.isEmpty {
                working = items.shuffled()
            }
        }
        .background(Color(.systemBackground))
    }

    private func evaluate() -> Bool {
        // Map die aktuelle Reihenfolge auf Indizes in „items“
        let currentIndices: [Int] = working.compactMap { items.firstIndex(of: $0) }
        return currentIndices == correctOrderIndices
    }
}
