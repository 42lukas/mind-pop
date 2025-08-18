//
//  QuestionCardRouter.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//


import SwiftUI

struct QuestionCardRouter: View {
    let question: Question
    @Binding var disablePaging: Bool

    var body: some View {
        GeometryReader { geo in
            getCard(for: question)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.clear)
        }
    }

    @ViewBuilder
    private func getCard(for question: Question) -> some View {
        switch question.body {
        case .singleChoice(let p):
            SingleChoiceCard(
                category: question.category,
                prompt: p.prompt,
                options: p.options,
                correctIndex: p.correctIndex,
                explanation: p.explanation
            )

        case .trueFalse(let p):
            TrueFalseCard(
                category: question.category,
                statement: p.statement,
                isTrue: p.isTrue,
                explanation: p.explanation
            )

        case .order(let p):
            OrderCard(
                category: question.category,
                prompt: p.prompt,
                items: p.items,
                correctOrderIndices: p.correctOrderIndices,
                explanation: p.explanation
            ) { dragging in
                disablePaging = dragging
            }
        }
    }
}
