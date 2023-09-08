//
//  PostingsFilter.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-09-07.
//

import SwiftUI

struct PostingsFilter: View {
    @StateObject private var viewModel = PostingsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !viewModel.filters.isEmpty {
                    HStack {
                        Button {
                            viewModel.clearAllFilters()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Theme.darkCyan)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem(.flexible())]) {
                                ForEach(viewModel.filters, id: \.self) { filter in
                                    FilterPill(title: filter, onRemove: {
                                        viewModel.remove(filter: filter)
                                    })
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(viewModel.postings, id: \.id) { posting in
                        PostingView(posting: posting, onTagPress: { tag in
                            viewModel.add(filter: tag)
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.top, 15)
            }
            .background(Theme.lightGrayCyan)
            .navigationTitle("Postings")
        }
    }
}

struct PostingView: View {
    let posting: Posting
    let onTagPress: (String) -> Void
    
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
                        Text("New").modifier(PillStyleModifier(pill: .new))
                    }
                    
                    if posting.featured {
                        Text("Featured").modifier(PillStyleModifier(pill: .featured))
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
                        Button(tag) {
                            onTagPress(tag)
                        }
                        .buttonStyle(TagButtonStyle())
                    }
                }
            }
            .padding()
            .padding(.top, 20)
            .overlay(alignment: .leading) {
                if posting.featured {
                    Theme.darkCyan
                        .frame(width: 5)
                }
            }
            .background(.white)
            .cornerRadius(8)
            .padding(.bottom, 25)
        }
    }
}

struct FilterPill: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .bold()
                .padding(.vertical, 8)
                .padding(.trailing, 8)
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 8)
        .background(Theme.darkCyan)
        .cornerRadius(4)
    }
}

// MARK: - Style Modifiers

struct TagButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .foregroundColor(Theme.darkCyan)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.lightGrayCyan)
            .cornerRadius(4)
    }
}

struct PillStyleModifier: ViewModifier {
    enum Pill {
        case new, featured
        
        var color: Color {
            switch self {
            case .new: return Theme.darkCyan
            case .featured: return .black
            }
        }
    }
    
    let pill: Pill
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .textCase(.uppercase)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(pill.color)
            .clipShape(Capsule())
    }
}

struct PostingsFilter_Previews: PreviewProvider {
    static var previews: some View {
        PostingsFilter()
    }
}

// MARK: - Helpers

final class PostingsViewModel: ObservableObject {
    @Published var postings: [Posting] = []
    @Published var filters: [String] = []
    
    private let allPostings: [Posting]
    private var currentFilters: Set<String> = []
    
    init() {
        let _postings = Bundle.main.decode([Posting].self, from: "postings.json")
        self.allPostings = _postings
        self.postings = _postings
    }
    
    func add(filter: String) {
        let (inserted, _) = currentFilters.insert(filter)
        guard inserted else { return }
        
        // Add to filter array so that the pills can be displayed
        filters.insert(filter, at: 0)
      
        // If we want to have a filter that's not exclusive
        // postings = allPostings.filter({ $0.allTags.contains(where: { $0 == filter })})
        
        // If we want to have a filter that's exclusive
        postings = allPostings.filter({ posting in
            currentFilters.isSubset(of: posting.allTags)
        })
    }
    
    func remove(filter: String) {
        guard let index = filters.firstIndex(where: { $0 == filter }) else { return }
        
        filters.remove(at: index)
        currentFilters.remove(filter)
        
        postings = allPostings.filter({ posting in
            currentFilters.isSubset(of: posting.allTags)
        })
    }
    
    func clearAllFilters() {
        filters = []
        currentFilters = []
        postings = allPostings
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
    
    var allTags: [String] {
        return [role, level] + languages + tools
    }
}

fileprivate struct Theme {
    static let darkCyan = Color(red: 91/255, green: 164/255, blue: 164/255)
    static let lightGrayCyan = Color(red: 238/255, green: 246/255, blue: 246/255)
    static let darkGrayCyan = Color(red: 123/255, green: 142/255, blue: 142/255)
    static let veryDarkGrayCyan = Color(red: 92/255, green: 122/255, blue: 122/255)
}
