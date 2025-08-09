//
//  LocalQuestionRepo.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import Foundation

// MARK: - Abstraktion

public protocol QuestionsRepository {
    /// Hol einen „Feed“-Batch im TikTok‑Stil.
    /// - Parameters:
    ///   - after: Cursor vom letzten Batch (nil für Start)
    ///   - limit: Anzahl Elemente
    ///   - locale: z. B. "de-DE"
    ///   - categories: optional Filter
    func fetchFeed(after: String?, limit: Int, locale: String?, categories: [String]?) async throws
    -> (items: [Question], nextCursor: String?)
}

// MARK: - Lokale Implementierung (Seed aus Bundle)

public final class LocalQuestionsRepository: QuestionsRepository {
    private let all: [Question]
    public init(seedFileName: String = "seed_questions") {
        // Lädt / decodiert einmalig
        if let url = Bundle.main.url(forResource: seedFileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let file = try? JSONDecoder().decode(QuestionsFile.self, from: data) {
            self.all = file.questions
        } else {
            self.all = []
            assertionFailure("seed_questions.json nicht gefunden/lesbar")
        }
    }

    /// Sehr simpler Cursor: wir nutzen den letzten Index als String
    public func fetchFeed(after: String?, limit: Int, locale: String?, categories: [String]?) async throws
    -> (items: [Question], nextCursor: String?) {
        let startIndex = Int(after ?? "0") ?? 0
        // Filter optional anwenden (locale/cats sind frei, weil Category ein String ist)
        let filtered = all.filter {
            (locale == nil || $0.locale == nil || $0.locale == locale) &&
            (categories == nil || categories!.isEmpty || categories!.contains($0.category))
        }
        guard startIndex < filtered.count else { return ([], nil) }
        let end = min(startIndex + limit, filtered.count)
        let slice = Array(filtered[startIndex..<end])
        let next = end < filtered.count ? String(end) : nil
        return (slice, next)
    }
}

/// JSON-Wrapper fürs Seed-File
public struct QuestionsFile: Codable {
    public let questions: [Question]
}
