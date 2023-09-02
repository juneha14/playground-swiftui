//
//  Splitter.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-30.
//

import SwiftUI

struct Splitter: View {
    init() {
        // Change the color of the navigation title
        // Currently, there's no way to do this using a modifier in SwiftUI
        let color = UIColor(cgColor: CGColor(red: 0/255, green: 73/255, blue: 77/255, alpha: 1))
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: color]
        navBarAppearance.titleTextAttributes = [.foregroundColor: color]
    }
    
    @State private var billAmount = ""
    @State private var numberOfPeople = ""
    @State private var tip: Tip?
    @State private var tipType: TipType = .custom(amount: 0)
    
    private var tipAmountPerPerson: Double {
        guard let bill = Double(billAmount), let numPeople = Double(numberOfPeople) else {
            return 0
        }
        
        switch tipType {
        case .percentage(let amount):
            return bill * amount / numPeople
        case .custom(let amount):
            return amount / numPeople
        }
    }
    
    private var totalAmountPerPerson: Double {
        guard let bill = Double(billAmount), let numPeople = Double(numberOfPeople) else {
            return 0
        }
        
        return (bill + tipAmountPerPerson) / numPeople
    }
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    SectionContent(title: "Bill") {
                        InputField(iconName: "dollarsign", placeholder: "0", value: $billAmount, keyboardType: .decimalPad)
                    }
                    
                    SectionContent(title: "Select Tip %") {
                        TipOptions(selectedTip: $tip, selectedTipType: $tipType)
                    }
                    
                    SectionContent(title: "Number of People") {
                        InputField(iconName: "person.fill", placeholder: "0", value: $numberOfPeople, keyboardType: .numberPad)
                    }
                    
                    VStack {
                        ResultAmount(title: "Tip Amount", amount: tipAmountPerPerson)
                        ResultAmount(title: "Total", amount: totalAmountPerPerson)
                        Button {
                            // Reset everything
                            billAmount = ""
                            numberOfPeople = ""
                            tip = nil
                            tipType = .custom(amount: 0)
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
    @Binding var selectedTip: Tip?
    @Binding var selectedTipType: TipType
    
    @State private var customTip = ""
    @FocusState private var isCustomTipFieldFocused: Bool
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(Tip.allCases, id: \.rawValue) { tip in
                if case .custom = tip {
                    TextField(tip.rawValue, text: $customTip)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .bold()
                        .foregroundColor(Theme.veryDarkGreen)
                        .padding(.vertical, 15)
                        .background(Theme.veryLightGrayGreen)
                        .cornerRadius(8)
                        .focused($isCustomTipFieldFocused)
                        .onTapGesture {
                            selectedTip = .custom
                        }
                        .onChange(of: customTip) { newValue in
                            if selectedTip == .custom {
                                selectedTipType = .custom(amount: Double(newValue) ?? 0)
                            }
                        }
                        .onChange(of: selectedTip) { newValue in
                            // Reset custom text field
                            customTip = ""
                            isCustomTipFieldFocused = false
                        }
                } else {
                    Button {
                        selectedTip = tip
                        selectedTipType = .percentage(amount: tip.percentage)
                    } label: {
                        Text(tip.rawValue)
                            .font(.headline)
                            .foregroundColor(selectedTip == tip ? Theme.veryDarkGreen : .white)
                            .frame(width: 140)
                            .padding()
                            .background(selectedTip == tip ? Theme.cyan : Theme.veryDarkGreen)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct ResultAmount: View {
    let title: String
    let amount: Double
    
    var body: some View {
        LabeledContent {
            Text(amount.formatted(.currency(code: "USD")))
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

// MARK: - Models

enum Tip: String, CaseIterable {
    case five = "5%"
    case ten = "10%"
    case fifteen = "15%"
    case twentyFive = "25%"
    case fifty = "50%"
    case custom = "Custom"
    
    var percentage: Double {
        switch self {
        case .five: return 0.05
        case .ten: return 0.1
        case .fifteen: return 0.15
        case .twentyFive: return 0.25
        case .fifty: return 0.50
        case .custom: return 0.00
        }
    }
}

enum TipType {
    case percentage(amount: Double)
    case custom(amount: Double)
}

// MARK: - Theme

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
