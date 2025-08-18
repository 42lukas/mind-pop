//
//  CategoryBackground.swift
//  mind-pop
//
//  Created by Lukas Karsten on 12.08.25.
//

import SwiftUI

enum CategoryBackground {
    static func imageName(for category: String) -> String {
        print("CATEGORY MAPPING INPUT:", category)
        switch category.lowercased() {
        case "arts", "art":                 return "BackgroundArt"
        case "general", "generalknowledge": return "BackgroundGeneralKnowledge"
        case "geography":                   return "BackgroundGeography"
        case "history":                     return "BackgroundHistory"
        case "language":                    return "BackgroundLanguage"
        case "logic":                       return "BackgroundLogic"
        case "math", "mathematics":         return "BackgroundMath"
        case "nature":                      return "BackgroundNature"
        case "politics":                    return "BackgroundPolitics"
        case "science":                     return "BackgroundScience"
        case "technology", "tech":          return "BackgroundTech"
        default:                            return "BackgroundGeneralKnowledge"
        }
    }
}
