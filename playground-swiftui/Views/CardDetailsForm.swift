//
//  CardDetailsForm.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-22.
//

import SwiftUI

// Navigate to new page when submitted form

struct CardDetailsForm: View {
    struct CardDetails: Identifiable {
        let id = UUID()
        var name: String
        var cardNumber: String
        var expiryMonth: String
        var expiryYear: String
        var cvv: String
    }
    
    @State private var details = CardDetails(name: "", cardNumber: "", expiryMonth: "", expiryYear: "", cvv: "")
    
    private var submitButtonEnabled: Bool {
        return !details.name.isEmpty &&
        !details.cardNumber.isEmpty &&
        !details.expiryMonth.isEmpty &&
        !details.expiryYear.isEmpty &&
        !details.cvv.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    // Header
                    ZStack {
                        GeometryReader { geo in
                            let offsetY = geo.frame(in: .global).minY
                            Image("bg-main-mobile")
                                .resizable()
                                .scaledToFill()
                                .scaleEffect(offsetY > 0 ? (offsetY + 300) / 300 : 1)
                                .offset(y: offsetY > 0 ? -offsetY : 0)
                        }
                        .frame(height: 300)
                        
                        BackCard(cvv: details.cvv)
                            .offset(x: 30, y: 20)
                        
                        FrontCard(cardNumber: details.cardNumber,
                                  name: details.name,
                                  expiryMonth: details.expiryMonth,
                                  expiryYear: details.expiryYear)
                            .offset(x: -30, y: 120)
                    }
                    
                    
                    // Form
                    Group {
                        Spacer()
                        Spacer()
                        
                        CardFormTextField(inputType: .name($details.name))
                        CardFormTextField(inputType: .cardNumber($details.cardNumber))
                        HStack(spacing: 24) {
                            CardFormTextField(inputType: .expiry(month: $details.expiryMonth, year: $details.expiryYear))
                            CardFormTextField(inputType: .cvv($details.cvv))
                        }
                        
                        Spacer()
                        
                        // Confirm button
                        VStack {
                            Button {
                                print("confirmed!")
                            } label: {
                                Text("Confirm")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.blue)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain) // Makes only the button clickable and not the entire row
                            .disabled(!submitButtonEnabled)
                        }
                    }
                    .padding(.horizontal)
                    .zIndex(-1) // Place it behind the header
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .ignoresSafeArea(edges: .top)
        }
    }
}

struct CardFormTextField: View {
    enum InputType {
        case name(Binding<String>)
        case cardNumber(Binding<String>)
        case expiry(month: Binding<String>, year: Binding<String>)
        case cvv(Binding<String>)
        
        var title: String {
            switch self {
            case .name: return "Cardholder name"
            case .cardNumber: return "Card number"
            case .expiry: return "Expiry date (MM/YY)"
            case .cvv: return "CVV"
            }
        }
        
        var placeholder: String {
            switch self {
            case .name: return "e.g. Jane Appleseed"
            case .cardNumber: return "e.g. 1234 5678 9123 0000"
            case .expiry: return "MM YY"
            case .cvv: return "CVV"
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .name: return .default
            case .cardNumber, .expiry, .cvv: return .numberPad
            }
        }
        
        var bindingValue: (Binding<String>, Binding<String>?) {
            get {
                switch self {
                case .name(let name): return (name, nil)
                case .cardNumber(let number): return (number, nil)
                case .expiry(let month, let year): return (month, year)
                case .cvv(let cvv): return (cvv, nil)
                }
            }
            set {
                switch self {
                case .name: self = .name(newValue.0)
                case .cardNumber: self = .cardNumber(newValue.0)
                case .expiry: self = .expiry(month: newValue.0, year: newValue.1!)
                case .cvv: self = .cvv(newValue.0)
                }
            }
        }
    }
    
    let inputType: InputType
   
    var body: some View {
        VStack(alignment: .leading) {
            Text(inputType.title)
                .font(.caption)
                .foregroundColor(.black)
                .textCase(.uppercase)
            HStack {
                if case .expiry(let bindingMonth, let bindingYear) = inputType {
                    let placeholder = inputType.placeholder.split(separator: " ")
                    TextField(placeholder[0], text: bindingMonth)
                        .modifier(FormTextModifier(keyboardType: inputType.keyboardType))
                        .modifier(FormValidatorModifier(inputType: inputType))
                    TextField(placeholder[1], text: bindingYear)
                        .modifier(FormTextModifier(keyboardType: inputType.keyboardType))
                        .modifier(FormValidatorModifier(inputType: inputType))
                } else {
                    TextField(inputType.placeholder, text: inputType.bindingValue.0)
                        .modifier(FormTextModifier(keyboardType: inputType.keyboardType))
                        .modifier(FormValidatorModifier(inputType: inputType))
                }
            }
        }
        .padding(.top)
    }
}

struct FormValidatorModifier: ViewModifier {
    let inputType: CardFormTextField.InputType
    
    @FocusState private var isFocused: Bool
    @State private var showErrorMessage = false
    
    func isValid() -> Bool {
        switch inputType {
        case .name(let name):
            return !name.wrappedValue.isEmpty
        case .cardNumber(let number):
            return number.wrappedValue.count == 16
        case .expiry(let month, let year):
            return month.wrappedValue.count == 2 && year.wrappedValue.count == 2
        case .cvv(let cvv):
            return cvv.wrappedValue.count == 3
        }
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
                .focused($isFocused)
                .onChange(of: isFocused) { newValue in
                    if !newValue {
                        showErrorMessage = !isValid()
                    }
                }
            Text(showErrorMessage ? "Incorrect!" : " ") // Empty string hack so that the view doesn't move up and down
                .bold()
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal, 1)
        }
    }
}

struct FormTextModifier: ViewModifier {
    let keyboardType: UIKeyboardType
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.2))
            .keyboardType(keyboardType)
    }
}

struct FrontCard: View {
    let cardNumber: String
    let name: String
    let expiryMonth: String
    let expiryYear: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                Circle()
                    .stroke(.white)
                    .frame(width: 10, height: 10)
            }
            
            Spacer()
            Group {
                Text(cardNumber.isEmpty ? "0000 0000 0000 0000" : cardNumber)
                    .bold()
                    .font(.callout)
                HStack {
                    Text(name.isEmpty ? "Jane Appleseed" : name)
                    Spacer()
                    Text(expiryMonth.isEmpty && expiryYear.isEmpty ? "00/00" : "\(expiryMonth)/\(expiryYear)")
                }
                .font(.caption)
                .padding(.vertical, 1)
            }
            .foregroundColor(.white)
        }
        .padding()
        .frame(width: 300, height: 180)
        .background(
            Image("bg-card-front")
                .resizable()
                .scaledToFill()
        )
        .clipped()
        .cornerRadius(8)
    }
}

struct BackCard: View {
    let cvv: String
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("bg-card-back")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 180)
                .clipped()
                .cornerRadius(8)
            
            Text(cvv.isEmpty ? "000" : cvv)
                .font(.caption)
                .foregroundColor(.white)
                .offset(x: -20)
        }
    }
}

struct CardDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsForm()
    }
}
