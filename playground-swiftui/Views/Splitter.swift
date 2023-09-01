//
//  Splitter.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-30.
//

import SwiftUI

struct Splitter: View {
    
    @State private var billAmount = ""
    @State private var numberOfPeople = ""
    
    init() {
        // Change the color of the navigation title
        // Currently, there's no way to do this using a modifier in SwiftUI
        let color = UIColor(cgColor: CGColor(red: 0/255, green: 73/255, blue: 77/255, alpha: 1))
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: color]
        navBarAppearance.titleTextAttributes = [.foregroundColor: color]
    }
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    SectionContent(title: "Bill") {
                        InputField(iconName: "dollarsign", placeholder: "0", value: $billAmount, keyboardType: .decimalPad)
                    }
                    
                    SectionContent(title: "Select Tip %") {
                        TipOptions()
                    }
                    
                    SectionContent(title: "Number of People") {
                        InputField(iconName: "person.fill", placeholder: "0", value: $numberOfPeople, keyboardType: .numberPad)
                    }
                    
                    VStack {
                        ResultAmount(title: "Tip Amount", amount: "$0.00")
                        ResultAmount(title: "Total", amount: "$0.00")
                        Button {
                            print("pressed")
                        } label: {
                            Text("RESET")
                                .bold()
                                .foregroundColor(Theme.veryDarkGreen)
                                .padding()
                                .frame(width: 300)
                                .background(Theme.cyan)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Theme.veryDarkGreen)
                    .cornerRadius(8)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .background(Theme.lightGrayGreen)
            .navigationTitle("Splitter")
        }
    }
}

struct TipOptions: View {
    enum Tips: String, CaseIterable {
        case five = "5%"
        case ten = "10%"
        case fifteen = "15%"
        case twentyFive = "25%"
        case fifty = "50%"
        case custom = "Custom"
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @State private var customTip = ""
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(Tips.allCases, id: \.rawValue) { tip in
                if case .custom = tip {
                    TextField(tip.rawValue, text: $customTip)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .bold()
                        .foregroundColor(Theme.veryDarkGreen)
                        .padding(.vertical, 15)
                        .background(Theme.veryLightGrayGreen)
                        .cornerRadius(8)
                } else {
                    Button {
                        //
                    } label: {
                        Text(tip.rawValue)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 140)
                            .padding()
                            .background(Theme.veryDarkGreen)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct Tip: View {
    let amount: String
    
    var body: some View {
        Button {
            //
        } label: {
            Text(amount)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 140)
                .padding()
                .background(Theme.veryDarkGreen)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

struct ResultAmount: View {
    let title: String
    let amount: String
    
    var body: some View {
        LabeledContent {
            Text(amount)
                .bold()
                .font(.title)
                .foregroundColor(Theme.cyan)
        } label: {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
            Text("/ person")
                .font(.caption2)
                .foregroundColor(Theme.veryLightGrayGreen)
        }
        .padding(.bottom)
    }
}

struct InputField: View {
    let iconName: String
    let placeholder: String
    let value: Binding<String>
    let keyboardType: UIKeyboardType
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Theme.lightGrayGreen)
            TextField(placeholder, text: value)
                .multilineTextAlignment(.trailing)
                .keyboardType(keyboardType)
                .foregroundColor(Theme.veryDarkGreen)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Theme.veryLightGrayGreen)
        .cornerRadius(8)
    }
}

struct SectionContent<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.darkGrayGreen)
            content()
        }
    }
}

fileprivate struct Theme {
    static let veryDarkGreen = Color(red: 0/255, green: 73/255, blue: 77/255)
    static let darkGrayGreen = Color(red: 94/255, green: 122/255, blue: 125/255)
    static let grayGreen = Color(red: 127/255, green: 156/255, blue: 159/255)
    static let lightGrayGreen = Color(red: 197/255, green: 228/255, blue: 231/255)
    static let veryLightGrayGreen = Color(red: 244/255, green: 250/255, blue: 250/255)
    static let cyan = Color(red: 38/255, green: 192/255, blue: 171/255)
}

struct Splitter_Previews: PreviewProvider {
    static var previews: some View {
        Splitter()
    }
}
