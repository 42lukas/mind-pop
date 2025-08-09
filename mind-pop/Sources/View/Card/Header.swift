//
//  Header.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct Header: View {
    let category: String
    var body: some View {
        HStack {
            Text(category.uppercased())
                .font(.caption).foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
}
