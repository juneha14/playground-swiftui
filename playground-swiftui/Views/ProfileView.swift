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
        
        static let faq: [FAQView.FAQ] = [
            .init(question: "How many team members can I invite?", answer: "There is no limit!"),
            .init(question: "What is the maximum file upload size?", answer: "No more than 2GB. All files in your account must fit your allotted storage space."),
            .init(question: "How do I reset my password?", answer: "Go to Settings > Password"),
            .init(question: "How do I cancel my subscription?", answer: "Text STOP to 101234"),
        ]
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
            
            
            // Accordion
            VStack {
                ForEach(Constants.faq) { faq in
                    FAQView(faq: faq)
                }
            }
            .padding()
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

struct FAQView: View {
    struct FAQ: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
    }
    
    let faq: FAQ
    
    @State private var isExpanded = false
    
    private struct Constants {
        static let chevronColor = Color(red: 244/255, green: 124/255, blue: 87/255)
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $isExpanded) {
                Text(faq.answer)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } label: {
                Text(faq.question)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold(isExpanded)
            }
            .accentColor(Constants.chevronColor)
            .padding(.vertical, 4)
            
            Divider()
                .frame(height: 1)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

// SizeModifiers

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

