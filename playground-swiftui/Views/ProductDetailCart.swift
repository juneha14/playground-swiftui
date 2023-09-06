//
//  ProductDetailCart.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-09-01.
//

import SwiftUI

struct ProductDetailCart: View {
    @StateObject var cart = Cart()
    
    var body: some View {
        TabView {
            ProductDetailsView(cart: cart)
                .tabItem {
                    Label("Product", systemImage: "house")
                }
            CartView(cart: cart)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
        }
    }
}

struct CartView: View {
    @ObservedObject var cart: Cart
    
    private func deleteProductFromCart(id: UUID) {
        cart.deleteItem(for: id)
    }
    
    var body: some View {
        NavigationStack {
            if cart.items.isEmpty {
                Text("Your cart is empty")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .navigationTitle("Cart")
            } else {
                List {
                    Section {
                        ForEach(cart.items) { item in
                            CartItemRow(item: item) { id in
                                deleteProductFromCart(id: id)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    if !cart.items.isEmpty {
                        Section {
                            Text("Checkout")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                                .background(Theme.orange)
                                .cornerRadius(8)
                        }
                        .padding(.top)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Cart")
            }
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    let deleteProductFromCart: (UUID) -> Void
    
    var body: some View {
        LabeledContent {
            Image(systemName: "trash")
                .resizable()
                .frame(width: 20, height: 20)
                .overlay(
                    Button("", action: {
                        deleteProductFromCart(item.id)
                    })
                )
        } label: {
            HStack(alignment: .top) {
                Image(item.thumbnailImageId)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text(item.price)
                    Spacer()
                    Text("Quantity: \(item.quantity)")
                        .font(.caption)
                }
                .frame(maxHeight: 70)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                deleteProductFromCart(item.id)
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
        }
    }
}

struct ProductDetailsView: View {
    @ObservedObject var cart: Cart
    
    private let productImageIds = [
        "shoe1",
        "shoe2",
        "shoe3",
        "shoe4"
    ]
    
    @State private var quantity = 0
    @State private var selectedPageIndex: Array.Index = 0
    @State private var addToCartSuccess = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // In <iOS 17, we need to use TabView which doubles as a UIPageViewController
            // For iOS 17, we can use a ScrollView to enable pagination
            ZStack {
                TabView(selection: $selectedPageIndex) {
                    ForEach(productImageIds, id: \.self) { imageId in
                        if let index = productImageIds.firstIndex(of: imageId) {
                            Image(imageId)
                                .resizable()
                                .scaledToFill()
                                .tag(index)
                        }
                    }
                }
                .frame(width: 395, height: 300)
                .tabViewStyle(.page)
                .animation(.easeIn, value: selectedPageIndex) // Slide animation when programmatically changing index with button
                
                HStack {
                    Button {
                        let newIndex = selectedPageIndex - 1
                        selectedPageIndex = max(0, newIndex)
                    } label: {
                        Image(systemName: "chevron.left")
                            .modifier(PaginationButtonModifier())
                            .padding(.leading)
                    }
                    Spacer()
                    Button {
                        let newIndex = selectedPageIndex + 1
                        selectedPageIndex = min(3, newIndex)
                    } label: {
                        Image(systemName: "chevron.right")
                            .modifier(PaginationButtonModifier())
                            .padding(.trailing)
                    }
                }
            }
            
            Group {
                VStack(alignment: .leading) {
                    Text("Sneaker Company")
                        .font(.headline)
                        .foregroundColor(Theme.orange)
                        .textCase(.uppercase)
                    
                    Text("Fall Limited Edition Sneakers")
                        .font(.title)
                        .bold()
                        .padding(.vertical, 1)
                    
                    Text("These low profile sneakers are perfect casual wear companion. Featuring a durable rubber outer sole, they'll withstand everything the weather can offer.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                LabeledContent {
                    Text("$250.00")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .strikethrough(true, color: .secondary)
                } label: {
                    HStack {
                        Text("$125.00")
                            .font(.title)
                            .bold()
                            .padding(.trailing, 4)
                        Text("50%")
                            .font(.subheadline)
                            .foregroundColor(Theme.orange)
                            .bold()
                            .padding(6)
                            .background(Theme.paleOrange)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Button {
                        let newQuantity = quantity - 1
                        quantity = max(0, newQuantity)
                    } label: {
                        Image(systemName: "minus").foregroundColor(Theme.orange)
                    }

                    Spacer()
                    Text(String(quantity))
                    Spacer()
                    
                    Button {
                        quantity += 1
                    } label: {
                        Image(systemName: "plus").foregroundColor(Theme.orange)
                    }
                }
                .bold()
                .padding()
                .background(Theme.lightGray)
                .cornerRadius(8)
                
                Button {
                    cart.add(item: CartItem(thumbnailImageId: "shoe1",
                                            title: "Fall Limited Edition Sneakers",
                                            price: "$125.00",
                                            quantity: quantity))
                    addToCartSuccess.toggle()
                } label: {
                    Label("Add to cart", systemImage: "cart")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.orange)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .padding(.vertical)
                .disabled(quantity == 0)
                .alert("Item added to cart!", isPresented: $addToCartSuccess, actions: {})
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ProductDetailCart_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailCart()
    }
}

// MARK: - Cart model observable object

class Cart: ObservableObject {
    @Published var items: [CartItem] = []
    
    func add(item: CartItem) {
        if let index = items.firstIndex(where: { item.title == $0.title }) {
            // If item already exists, update the quantity
            items[index].quantity = item.quantity
        } else {
            items.append(item)
        }
    }
    
    func deleteItem(for id: UUID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let thumbnailImageId: String
    let title: String
    let price: String
    var quantity: Int
}

// MARK: - Modifiers

fileprivate struct PaginationButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 5, height: 5)
            .bold()
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .clipShape(Circle())
    }
}

// MARK: - Theme

fileprivate struct Theme {
    static let orange = Color.orange
    static let paleOrange = Color(red: 255/255, green: 237/255, blue: 224/255)
    static let lightGray = Color(red: 247/255, green: 248/255, blue: 253/255)
}
