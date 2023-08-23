//
//  CardDetailsForm.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-22.
//

import SwiftUI

struct CardDetailsForm: View {
    @State private var name = ""
    
    var body: some View {
        NavigationView {
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
                        BackCard()
                            .offset(x: 30, y: 20)
                        FrontCard()
                            .offset(x: -30, y: 120)
                    }
                    
                    
                    // Form
                    Group {
                        Spacer()
                        Spacer()
                        
                        CardFormTextField(title: "Cardholder name",
                                          placeholder: "e.g. Jane Appleseed",
                                          value: $name,
                                          keyboardType: .default
                        )
                        CardFormTextField(title: "Card number",
                                          placeholder: "e.g. 1234 5678 9123 0000",
                                          value: $name,
                                          keyboardType: .numberPad
                        )
                        HStack(spacing: 24) {
                            CardFormTextField(title: "Expiry date (MM/YY)",
                                              placeholder: "MM",
                                              value: $name,
                                              keyboardType: .numberPad,
                                              secondaryPlaceholder: "YY",
                                              secondaryValue: $name,
                                              isDouble: true
                            )
                            CardFormTextField(title: "CVC",
                                              placeholder: "e.g. 123",
                                              value: $name,
                                              keyboardType: .numberPad
                            )
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
    let title: String
    let placeholder: String
    let value: Binding<String>
    let keyboardType: UIKeyboardType
    let secondaryPlaceholder: String?
    let secondaryValue: Binding<String>?
    let isDouble: Bool
    
    init(title: String, placeholder: String, value: Binding<String>, keyboardType: UIKeyboardType, secondaryPlaceholder: String? = nil, secondaryValue: Binding<String>? = nil, isDouble: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self.value = value
        self.keyboardType = keyboardType
        self.secondaryPlaceholder = secondaryPlaceholder
        self.secondaryValue = secondaryValue
        self.isDouble = isDouble
    }
   
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
                .textCase(.uppercase)
            HStack {
                TextField(placeholder, text: value)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.2))
                    .keyboardType(keyboardType)
                
                if isDouble == true, let secondaryPlaceholder = secondaryPlaceholder, let secondaryValue = secondaryValue {
                    TextField(secondaryPlaceholder, text: secondaryValue)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.2))
                }
            }
        }
        .padding(.top)
    }
}

struct FrontCard: View {
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
                Text("0000 0000 0000 0000 0000")
                    .bold()
                    .font(.callout)
                HStack {
                    Text("Jane Appleseed")
                    Spacer()
                    Text("00/00")
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
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("bg-card-back")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 180)
                .clipped()
                .cornerRadius(8)
            
            Text("000")
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
