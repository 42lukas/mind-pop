//
//  FeedView.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct FeedView: View {
    @State private var vm = FeedViewModel(repo: LocalQuestionsRepository())
    @State private var disablePaging = false
    @State private var visibleQuestionID: String?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let question = currentQuestion {
                    Image(CategoryBackground.imageName(for: question.category))
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width)
                        .clipped()
                        .ignoresSafeArea()

                    LinearGradient(
                        colors: [Color.black.opacity(0.45), Color.black.opacity(0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.items, id: \.id) { question in
                            GeometryReader { cardGeo in
                                let frame = cardGeo.frame(in: .global)
                                Color.clear
                                    .preference(key: VisibleQuestionKey.self, value: isVisible(frame: frame, geo: geo) ? question.id : nil)

                                QuestionCardRouter(question: question, disablePaging: $disablePaging)
                                    .frame(width: cardGeo.size.width, height: geo.size.height)
                            }
                            .frame(height: geo.size.height)
                            .containerRelativeFrame(.vertical)
                            .onAppear {
                                if vm.items.last?.id == question.id {
                                    Task { await vm.loadMore() }
                                }
                            }
                        }
                    }
                    .onPreferenceChange(VisibleQuestionKey.self) { newID in
                        if let newID = newID {
                            visibleQuestionID = newID
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollDisabled(disablePaging)
                .task { await vm.refresh() }

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
            }.ignoresSafeArea(.all)
        }
    }

    private func isVisible(frame: CGRect, geo: GeometryProxy) -> Bool {
        // Mittlerer Bereich des Bildschirms
        let screenMidY = geo.frame(in: .global).midY
        return frame.minY <= screenMidY && frame.maxY >= screenMidY
    }

    private var currentQuestion: Question? {
        guard let id = visibleQuestionID else { return nil }
        return vm.items.first { $0.id == id }
    }
}

#Preview {
    FeedView()
}
