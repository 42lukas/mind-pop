//
//  QuizModel.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import Foundation

// MARK: - Kernmodell

/// Top-Level Frageobjekt für den Feed
public struct Question: Identifiable, Codable, Equatable {
    public let id: String                 // UUID vom Backend oder lokal generiert
    public let category: String           // bewusst String -> neue Kategorien ohne App-Update
    public let locale: String?            // z.B. "de-DE" (optional)
    public let body: QuestionBody         // eigentlicher Inhalt (payload)
    public let version: Int               // für spätere Schema-Änderungen; starte mit 1

    public init(id: String = UUID().uuidString,
                category: String,
                locale: String? = nil,
                body: QuestionBody,
                version: Int = 1) {
        self.id = id
        self.category = category
        self.locale = locale
        self.body = body
        self.version = version
    }
}

// MARK: - Payload-Union (modular, gut erweiterbar)

/// Union-Typ für verschiedene Fragetypen.
/// JSON-Form: { "type": "...", "data": { ... } }
public enum QuestionBody: Codable, Equatable {
    case singleChoice(SingleChoice)
    case order(Order)             // Drag & Drop Reihenfolge
    case trueFalse(TrueFalse)

    private enum CodingKeys: String, CodingKey { case type, data }
    private enum Child: String, Codable { case singleChoice, order, trueFalse }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Child.self, forKey: .type) {
        case .singleChoice: self = .singleChoice(try c.decode(SingleChoice.self, forKey: .data))
        case .order:        self = .order(       try c.decode(Order.self,        forKey: .data))
        case .trueFalse:    self = .trueFalse(   try c.decode(TrueFalse.self,    forKey: .data))
            
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .singleChoice(let p):
            try c.encode(Child.singleChoice, forKey: .type)
            try c.encode(p, forKey: .data)
        case .order(let p):
            try c.encode(Child.order, forKey: .type)
            try c.encode(p, forKey: .data)
        case .trueFalse(let p):
            try c.encode(Child.trueFalse, forKey: .type)
            try c.encode(p, forKey: .data)
        }
    }
}

// MARK: - Konkrete Payloads (simpel gehalten)

public struct SingleChoice: Codable, Equatable {
    public let prompt: String             // Frage
    public let options: [String]          // Antwortmöglichkeiten
    public let correctIndex: Int          // 0-basiert
    public let explanation: String?       // optionaler Hinweis/Begründung
}

public struct Order: Codable, Equatable {
    public let prompt: String             // Anweisung
    public let items: [String]            // zu sortierende Elemente
    public let correctOrderIndices: [Int] // Zielreihenfolge (0-basiert, Länge == items.count)
    public let explanation: String?
}

public struct TrueFalse: Codable, Equatable {
    public let statement: String          // Aussage
    public let isTrue: Bool               // wahr/falsch
    public let explanation: String?
}
