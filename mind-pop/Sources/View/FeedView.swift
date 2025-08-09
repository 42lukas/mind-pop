//
//  FeedView.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct FeedView: View {
    @State private var vm = FeedViewModel(repo: LocalQuestionsRepository())

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(vm.items.enumerated()), id: \.1.id) { (idx, q) in
                    QuestionCardRouter(question: q)
                        .frame(height: UIScreen.main.bounds.height) // quasi „Full screen card“
                        .onAppear {
                            // Infinite load near the end
                            if idx >= vm.items.count - 3 {
                                Task { await vm.loadMore() }
                            }
                        }
                }

                if vm.isLoading {
                    ProgressView().frame(height: 120)
                }
            }
            .scrollTargetLayout() // wichtig für paging
        }
        .scrollTargetBehavior(.paging) // „snap“ pro Karte
        .ignoresSafeArea(edges: .bottom)
        .task { await vm.refresh() }
        .overlay(alignment: .top) {
            if let msg = vm.errorMessage {
                Text(msg).padding(8).background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 12)
            }
        }
    }
}

#Preview {
    FeedView()
}
