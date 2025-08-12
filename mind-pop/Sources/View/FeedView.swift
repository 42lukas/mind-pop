//
//  FeedView.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct FeedView: View {
    @State private var disablePaging = false
    @State private var vm = FeedViewModel(repo: LocalQuestionsRepository())
    @State private var focusedID: String? // zentriertes Item im Feed

    var body: some View {
        ZStack {
            // 1) Kategorie-Background basierend auf der fokussierten Frage
            if let q = currentQuestion {
                let bgName = CategoryBackground.imageName(for: q.category)
                Image(bgName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [Color.black.opacity(0.45), Color.black.opacity(0.08)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
            } else {
                // Fallback
                Color.white.ignoresSafeArea()
            }

            // 2) Vertikaler „TikTok“-Feed
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(vm.items, id: \.id) { q in
                        QuestionCardRouter(
                            question: q,
                            disablePaging: $disablePaging
                        )
                        .containerRelativeFrame(.vertical)   // volle Screen-Höhe pro Karte
                        .id(q.id)                             // wichtig für scrollPosition
                        .onAppear {
                            // Preload
                            if let idx = vm.items.firstIndex(where: { $0.id == q.id }),
                               idx >= vm.items.count - 3 {
                                Task { await vm.loadMore() }
                            }
                        }
                    }

                    if vm.isLoading {
                        ProgressView()
                            .containerRelativeFrame(.vertical)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollDisabled(disablePaging)
            .scrollPosition(id: $focusedID, anchor: .center) // trackt die zentrierte Karte
            .task { await vm.refresh() }
            .onChange(of: vm.items.count) { _, _ in
                // Beim ersten Laden: fokus auf erste Frage setzen, damit BG sofort stimmt
                if focusedID == nil { focusedID = vm.items.first?.id }
            }

            // 3) Fehler-Overlay
            if let msg = vm.errorMessage {
                VStack {
                    Text(msg)
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }

    // aktuell zentrierte Frage
    private var currentQuestion: Question? {
        if let id = focusedID { return vm.items.first(where: { $0.id == id }) }
        return vm.items.first
    }
}

#Preview {
    FeedView()
}
