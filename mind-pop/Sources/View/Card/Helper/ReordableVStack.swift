//
//  ReordableVStack.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct ReorderableVStack<Item: Identifiable & Equatable, Row: View>: View where Item.ID: Hashable {
    @Binding var items: [Item]
    let row: (Item, Bool) -> Row            // Bool = ist aktuell im Drag

    // Zustand für Drag
    @State private var draggingItem: Item?
    @State private var dragTranslation: CGFloat = 0

    /// grobe Zeilenhöhe (inkl. vertikalem Spacing). Je nach Row anpassen.
    private let rowHeight: CGFloat = 56

    var body: some View {
        VStack(spacing: 10) {
            ForEach(items) { item in
                let isDragging = (draggingItem == item)

                row(item, isDragging)
                    .scaleEffect(isDragging ? 1.02 : 1.0)
                    .shadow(color: isDragging ? .black.opacity(0.12) : .clear, radius: 8, x: 0, y: 6)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 8)
                    }
                    // WICHTIG: highPriorityGesture am View (nicht auf dem Gesture-Typ)
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 2)
                            .onChanged { value in
                                if draggingItem == nil { draggingItem = item }
                                dragTranslation = value.translation.height
                                reorderIfNeeded(from: item, translationY: dragTranslation)
                            }
                            .onEnded { _ in
                                draggingItem = nil
                                dragTranslation = 0
                            }
                    )
            }
        }
        .animation(.spring(response: 0.22, dampingFraction: 0.85), value: items)
    }

    private func reorderIfNeeded(from item: Item, translationY: CGFloat) {
        guard let fromIndex = items.firstIndex(of: item) else { return }

        // wie viele "Reihen" sind wir vertikal gewandert?
        let offsetRows = Int((translationY / rowHeight).rounded())
        let toIndex = max(0, min(items.count - 1, fromIndex + offsetRows))

        guard toIndex != fromIndex else { return }

        withAnimation(.spring(response: 0.22, dampingFraction: 0.85)) {
            items.move(fromOffsets: IndexSet(integer: fromIndex),
                       toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}

// MARK: - Helpers (Layout/Overlay für den „schwebenden“ Row)

private struct DragProxy: View {
    let item: AnyHashable
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(key: DragRectKey.self, value: [item: geo.frame(in: .global)])
        }
    }
}

private struct DraggableRow<Content: View>: View {
    let content: Content
    let offset: CGFloat
    let index: Int
    var body: some View {
        content
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color(.tertiarySystemBackground)))
            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.black.opacity(0.06)))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
            .offset(y: offset + CGFloat(index) * 64) // 64 ≈ row height incl. spacing
            .allowsHitTesting(false)
    }
}

private struct DragRectKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGRect] = [:]
    static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
