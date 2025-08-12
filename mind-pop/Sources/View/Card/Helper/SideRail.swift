//
//  SideRail.swift
//  mind-pop
//
//  Created by Lukas Karsten on 09.08.25.
//

import SwiftUI

struct SideRail: View {
    let category: String
    let avatarURL: URL?

    @State private var liked = false
    @State private var bookmarked = false
    @State private var likeCount = 123
    @State private var commentCount = 12
    @State private var shareCount = 3

    var body: some View {
        VStack {
            Spacer()

            Button { bookmarked.toggle() } label: {
                VStack(spacing: 6) {
                    Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title2)
                    Text("Merken").font(.caption2)
                }
                .foregroundStyle(Color.textPrimary)
            }

            Button {
                
            } label: {
                VStack(spacing: 6) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.title2)
                    Text("\(shareCount)").font(.caption2)
                }.foregroundStyle(Color.textPrimary)
            }.padding(.top, 14)

            Button {
                liked.toggle()
                likeCount += liked ? 1 : -1
            } label: {
                VStack(spacing: 6) {
                    Image(systemName: liked ? "heart.fill" : "heart")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(liked ? Color.accent : Color.textPrimary)
                    Text("\(likeCount)").font(.caption2).foregroundStyle(Color.textPrimary)
                }
            }.padding(.top, 14)

            // Avatar
            ZStack {
                Circle().fill(Color.brandWhite.opacity(0.9)).frame(width: 56, height: 56)
                if let url = avatarURL {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.fill").resizable().scaledToFit().padding(6)
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill").resizable().scaledToFit().padding(6)
                        .frame(width: 56, height: 56).foregroundStyle(.secondary)
                }
            }.padding(.top, 14)
            
            Text(category.uppercased())
                .font(.caption2).bold()
                .padding(.horizontal, 8).padding(.top, 2)
                .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
                .foregroundStyle(Color.textPrimary)
            
        }
        .padding(.bottom, 12)
    }
}

#Preview {
    SideRail(category: "Science", avatarURL: URL(string: "https://picsum.photos/200"))
        .background(Color.gray.opacity(0.2))
}
