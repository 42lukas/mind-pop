//
//  FeedViewModel.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import Foundation
import Observation

@MainActor
@Observable
final class FeedViewModel {
    // Input
    private let repo: QuestionsRepository
    private let locale: String?
    private let categories: [String]?

    // State
    private(set) var items: [Question] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private var nextCursor: String?
    private var hasMore = true

    init(repo: QuestionsRepository, locale: String? = "de-DE", categories: [String]? = nil) {
        self.repo = repo
        self.locale = locale
        self.categories = categories
    }

    func refresh(limit: Int = 12) async {
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let res = try await repo.fetchFeed(after: nil, limit: limit, locale: locale, categories: categories)
            items = res.items
            nextCursor = res.nextCursor
            hasMore = (res.nextCursor != nil)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadMore(limit: Int = 10) async {
        guard !isLoading, hasMore else { return }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let res = try await repo.fetchFeed(after: nextCursor, limit: limit, locale: locale, categories: categories)
            items.append(contentsOf: res.items)
            nextCursor = res.nextCursor
            hasMore = (res.nextCursor != nil)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
