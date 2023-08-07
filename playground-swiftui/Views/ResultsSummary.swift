//
//  ResultsSummary.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-07.
//

import SwiftUI

struct ResultsSummary: View {
    var body: some View {
        VStack {
            ScrollView {
                // Your results section
                VStack {
                    Text("Your Result")
                        .foregroundColor(.white)
                        .font(.headline)
                    VStack {
                        Text("76")
                            .font(.largeTitle)
                            .bold()
                        Text("of 100")
                            .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .padding(6)
                    .background(.indigo)
                    .clipShape(Circle())
                    
                    VStack {
                        Text("Great")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 1)
                        Text("You scored higher than 65% of the people who have taken these tests.")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 80)
                .padding([.bottom, .leading, .trailing], 40)
                .background(Color(red: 120/255, green: 87/255, blue: 255/255).opacity(0.8))
                .cornerRadius(20)
                
                // Summary section
                VStack(alignment: .leading) {
                    Text("Summary")
                        .padding(.bottom)
                        .font(.headline)
                        .bold()
                    SummaryRow(type: .reaction, score: 80)
                    SummaryRow(type: .memory, score: 92)
                    SummaryRow(type: .verbal, score: 61)
                    SummaryRow(type: .visual, score: 72)
                }
                .padding()
            }
            .ignoresSafeArea(.container, edges: [.top])
            
            // Footer button
            Button {
                print("Button pressed!")
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.indigo)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
            }

        }
    }
}

struct SummaryRow: View {
    enum ResultType: String {
        case reaction = "Reaction"
        case memory = "Memory"
        case verbal = "Verbal"
        case visual = "Visual"
    }
    let iconNameForResultType: [ResultType: String] = [
        ResultType.reaction: "bolt",
        ResultType.memory: "brain",
        ResultType.verbal: "ellipsis.message",
        ResultType.visual: "eye",
    ]
    let backgroundColorForResultType: [ResultType: Color] = [
        ResultType.reaction: Color(red: 255/255, green: 87/255, blue: 87/255),
        ResultType.memory: Color(red: 255/255, green: 176/255, blue: 31/255),
        ResultType.verbal: Color(red: 0/255, green: 189/255, blue: 145/255),
        ResultType.visual: Color(red: 17/255, green: 37/255, blue: 212/255),
    ]
    
    let type: ResultType
    let score: Int
    
    var scoreAttributedString: Text {
        return Text("\(score)").bold() + Text(" / 100").foregroundColor(.gray)
    }
    
    var body: some View {
        HStack {
            Image(systemName: iconNameForResultType[type] ?? "")
            Text(type.rawValue)
                .bold()
            Spacer()
            scoreAttributedString
                .foregroundColor(.black)
        }
        .foregroundColor(backgroundColorForResultType[type] ?? .white)
        .padding(14)
        .background(backgroundColorForResultType[type]?.opacity(0.3) ?? .clear)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .padding(.bottom, 8)
    }
}

struct ResultsSummary_Previews: PreviewProvider {
    static var previews: some View {
        ResultsSummary()
    }
}
