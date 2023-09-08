//
//  PostingsFilter.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-09-07.
//

import SwiftUI

struct PostingsFilter: View {
    let postings = Bundle.main.decode([Posting].self, from: "postings.json")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Button {
                        // clear all filters
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Theme.darkCyan)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            ForEach(0...10, id: \.self) { _ in
                                FilterPill(title: "Frontend")
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 15)
                
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(postings, id: \.id) { posting in
                        PostingView(posting: posting)
                    }
                }
                .padding(.horizontal)
            }
            .background(Theme.lightGrayCyan)
            .navigationTitle("Postings")
        }
    }
}

struct PostingView: View {
    let posting: Posting
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(posting.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .overlay(Circle().stroke(.white, lineWidth: 4))
                .clipShape(Circle())
                .offset(x: 20, y: -20)
                .zIndex(2)
            
            VStack(alignment: .leading) {
                LabeledContent {
                    if posting.new {
                        FeaturedPill(title: "New")
                    }
                    
                    if posting.featured {
                        FeaturedPill(title: "Featured")
                    }
                } label: {
                    Text(posting.company)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Theme.darkCyan)
                }
                
                Text(posting.position)
                    .font(.subheadline)
                    .bold()
                
                HStack {
                    Text(posting.postedAt)
                    Text("·")
                    Text(posting.contract)
                    Text("·")
                    Text(posting.location)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 1)
                
                Divider()
                    .padding(.vertical, 8)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], alignment: .leading) {
                    let tags = [posting.role, posting.level] + posting.languages + posting.tools
                    ForEach(tags, id: \.self) { tag in
                        Tag(title: tag)
                    }
                }
            }
            .padding()
            .padding(.top, 20)
            .background(.white)
            .cornerRadius(8)
            .padding(.bottom, 25)
        }
    }
}

struct FilterPill: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .bold()
                .padding(.vertical, 4)
                .padding(.trailing, 8)
            Button {
                //
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 8)
        .background(Theme.darkCyan)
        .cornerRadius(4)
    }
}

struct Tag: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.caption)
            .foregroundColor(Theme.darkCyan)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.lightGrayCyan)
            .cornerRadius(4)
    }
}

struct FeaturedPill: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .textCase(.uppercase)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(title == "New" ? Theme.darkCyan : .black)
            .clipShape(Capsule())
        
    }
}

struct PostingsFilter_Previews: PreviewProvider {
    static var previews: some View {
        PostingsFilter()
    }
}

struct Posting: Codable {
    var id: Int
    var company: String
    var logo: String
    var new: Bool
    var featured: Bool
    var position: String
    var role: String
    var level: String
    var postedAt: String
    var contract: String
    var location: String
    var languages: [String]
    var tools: [String]
}

fileprivate struct Theme {
    static let darkCyan = Color(red: 91/255, green: 164/255, blue: 164/255)
    static let lightGrayCyan = Color(red: 238/255, green: 246/255, blue: 246/255)
    static let darkGrayCyan = Color(red: 123/255, green: 142/255, blue: 142/255)
    static let veryDarkGrayCyan = Color(red: 92/255, green: 122/255, blue: 122/255)
}
