//
//  InteractivePricing.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-28.
//

import SwiftUI

struct InteractivePricing: View {
    let pageViewsForPrice: [(pageView: String, price: Double)] = [
        (pageView: "10K", price: 8),
        (pageView: "50K", price: 12),
        (pageView: "100K", price: 16),
        (pageView: "500K", price: 24),
        (pageView: "1M", price: 36),
    ]
    
    @State private var index: Double = 2
    @State private var isToggleOn = false
    
    private var price: String {
        var price = pageViewsForPrice[Int(index)].price
        if isToggleOn {
            price -= (price * 0.25)
        }
        
        return String(price.formatted(.currency(code: "USD")))
    }
    
    var body: some View {
        ScrollView {
           HeaderDescription()
            
            VStack(spacing: 25) {
                Text("\(pageViewsForPrice[Int(index)].pageView) PAGEVIEWS")
                    .contentFont()
                
                Slider(
                    value: $index,
                    in: 0...Double(pageViewsForPrice.count - 1),
                    step: 1
                )
                .frame(width: 300)
                
                HStack {
                    Text(price)
                        .font(.title)
                        .bold()
                    Text("/ \(!isToggleOn ? "month" : "year")")
                        .contentFont()
                }
                
                HStack {
                    Text("Monthly Billing")
                        .contentFont()
                    
                    Toggle("", isOn: $isToggleOn)
                        .labelsHidden()
                        .tint(Color(red: 205/255, green: 215/255, blue: 238/255))
                    
                    HStack {
                        Text("Yearly Billing")
                            .contentFont()
                        
                        Text("-25%")
                            .font(.caption2)
                            .foregroundColor(.red)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.red.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                .padding(.leading, 28)
                
                Divider()
                    .frame(height: 1)
                    .padding(.top)
                
                VStack {
                    FeatureHighlight(title: "Unlimited websites")
                    FeatureHighlight(title: "100% data ownership")
                    FeatureHighlight(title: "Email reports")
                    
                    Button {
                        print("Start my trial button pressed")
                    } label: {
                        Text("Start my trial")
                            .padding(.vertical)
                            .padding(.horizontal, 80)
                            .foregroundColor(Color(red: 189/255, green: 204/255, blue: 255/255))
                            .background(Color(red: 41/255, green: 51/255, blue: 86/255))
                            .clipShape(Capsule())
                    }
                    .padding(.top)
                }
            }
            .padding(.vertical, 30)
            .background(RoundedRectangle(cornerRadius: 12).fill(.white).shadow(color: .secondary.opacity(0.5), radius: 0.5))
        }
        .padding(.horizontal)
        .background(Color(red: 250/255, green: 251/255, blue: 255/255))
    }
}

struct FeatureHighlight: View {
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 10, height: 10)
                .scaledToFill()
                .foregroundColor(.green)
            Text(title)
                .contentFont()
        }
    }
}

struct HeaderDescription: View {
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .stroke(.gray)
                    .opacity(0.5)
                    .frame(width: 100, height: 100)
                Circle()
                    .stroke(.gray)
                    .opacity(0.5)
                    .frame(width: 80, height: 80)
                    .offset(x: 40, y: -50)
            }
            .padding(.top, 50)
            
            VStack {
                Text("Simple, traffic-based pricing")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 1)
                Group {
                    Text("Sign up for our 30 day trial")
                    Text("No credit card required")
                }
                .contentFont()
            }
        }
    }
}

fileprivate extension View {
    func contentFont() -> some View {
        self.modifier(ContentFontModifier())
    }
}

struct ContentFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(Color(red: 133/255, green: 143/255, blue: 173/255))
    }
}

struct InteractivePricing_Previews: PreviewProvider {
    static var previews: some View {
        InteractivePricing()
    }
}
