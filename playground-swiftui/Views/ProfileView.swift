//
//  ProfileView.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-09.
//

import SwiftUI

struct ProfileView: View {
    private struct Constants {
        static let backgroundHeight = 170.0
        static let backgroundCoordinateSpace = "background-coordinate-space"
    }
    
    @State private var backgroundOffsetY: CGFloat = 0
    
    var body: some View {
        ScrollView {
            GeometryReader { geo in
                let minY = geo.frame(in: .global).minY
                let isScrolledDown = minY > 0
                
                Image("bg-pattern-card")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width)
                    .scaleEffect(isScrolledDown ? (minY + Constants.backgroundHeight) / Constants.backgroundHeight : 1) // scale up image when scrolled down
                    .blur(radius: isScrolledDown ? minY * 0.05 : 0) // blur image when scrolled down
                    .offset(y: isScrolledDown ? -minY : 0) // make it sticky to top when scrolled down
            }
            .frame(height: Constants.backgroundHeight)
            
            // Profile header
            VStack {
                // Name and location
                VStack {
                    Image("victor")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 4))
                        .padding(.bottom)
                    HStack {
                        Text("Victor Crest").bold()
                        Text("26").foregroundColor(.gray)
                    }
                    .font(.headline)
                    Text("London")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 1)
                }

                Divider()
                    .frame(height: 1)
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                // Stats
                HStack(spacing: 50) {
                    StatView(count: 80, title: "Followers")
                    StatView(count: 803, title: "Likes")
                    StatView(count: 2, title: "Photos")
                }
            }
            .padding(.bottom)
            .padding(.top, -50)
        }
        .ignoresSafeArea()
    }
}

struct StatView: View {
    let count: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(count)K")
                .font(.headline)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo in
                Color.clear.preference(key: SizePreferenceKey.self, value: geo.size)
            }
        )
    }
}

