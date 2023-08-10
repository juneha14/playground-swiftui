//
//  InteractiveRating.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-07.
//

import SwiftUI

fileprivate struct InteractiveRating: View {
    @ObservedObject var store: Store
    
    @State private var selectedRating: Int?
    
    private var isButtonDisabled: Bool {
        return selectedRating == nil
    }
    
    private struct Themes {
        static let lightGray = Color(red: 124/255, green: 135/255, blue: 152/255)
        static let darkGray = Color(red: 18/255, green: 20/255, blue: 23/255)
        static let darkBlue = Color(red: 37/255, green: 45/255, blue: 55/255)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                    .padding()
                    .background(Themes.darkGray)
                    .clipShape(Circle())
                
                Text("How did we do?")
                    .foregroundColor(.white)
                    .font(.headline)
                    .bold()
                    .padding(.bottom, 2)
                Text("Please let us know how we did with your support request. All feedback is appreciated to help us improve our offering!")
                    .foregroundColor(.white).opacity(0.8)
                    .font(.subheadline)
                
                HStack {
                    ForEach((1...5), id: \.self) { num in
                        Button {
                            selectedRating = num
                        } label: {
                            Text("\(num)")
                                .foregroundColor(selectedRating == num ? .white : Themes.lightGray)
                                .padding()
                                .background(selectedRating == num ? .orange : Themes.darkGray)
                                .clipShape(Circle())
                            if num < 5 {
                                Spacer()
                            }
                        }
                    }
                }
                
                Button {
                    // Toggle global store showRatingFeedback property to hide the view
                    store.showRatingFeedback.toggle()
                } label: {
                    Text("Submit")
                        .foregroundColor(isButtonDisabled ? Themes.lightGray : .white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(isButtonDisabled ? Themes.darkGray : .orange)
                        .cornerRadius(20)
                        .padding(.top)
                }
                .disabled(isButtonDisabled)
            }
            .frame(width: geometry.size.width * 0.8)
            .padding()
            .background(Themes.darkBlue)
            .cornerRadius(20)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

fileprivate class Store: ObservableObject {
    @Published var showRatingFeedback = false
}

fileprivate struct Content: View {
    @StateObject var store = Store()
    @State var test = false
    
    var body: some View {
        ZStack {
            VStack {
                Button("Show rating feedback") {
                    store.showRatingFeedback.toggle()
                }
                .buttonStyle(.borderedProminent)
                
                if test {
                    Text("Hello")
                        .padding()
                        .foregroundColor(.white)
                        .background(.red)
                        .transition(.scale)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .animation(.default, value: test)
            .blur(radius: store.showRatingFeedback ? 200 : 0)
            
            if store.showRatingFeedback {
                InteractiveRating(store: store)
            }
        }
    }
}

struct InteractiveRating_Previews: PreviewProvider {
    static var previews: some View {
        Content()
    }
}
