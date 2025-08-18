//
//  VisibleQuestionKey.swift
//  mind-pop
//
//  Created by Lukas Karsten on 18.08.25.
//

import SwiftUI

struct VisibleQuestionKey: PreferenceKey {
    static var defaultValue: String? = nil

    static func reduce(value: inout String?, nextValue: () -> String?) {
        if let newValue = nextValue() {
            value = newValue
        }
    }
}
