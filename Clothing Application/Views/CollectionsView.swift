//
//  CollectionsView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import SwiftUI

struct CollectionsView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedProducts: [Product] = [] // State to track selected products
    @Binding var cartItemsCount: Int
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                        Text("Collections")
                            .font(.title)
                            .fontWeight(.regular)
                        Spacer()
                        Image(systemName: "cart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        TextField("Search Products", text: $searchText)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .foregroundColor(.black)
                            .onTapGesture {
                                isSearching = true
                            }
                    }
                    .background(Color.gray.opacity(0))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    if isSearching {
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                ForEach(filteredProducts) { product in
                                    NavigationLink(destination: ProductDetailView(product: product, selectedProducts: $selectedProducts, cartItemsCount: $cartItemsCount)) {
                                        Text(product.name)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.8))
                                    .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                    } else {
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                CollectionOptionView(title: "NEW ARRIVALS")
                                CollectionOptionView(title: "DRESSES")
                                CollectionOptionView(title: "TOPS")
                                CollectionOptionView(title: "OUTERWEAR")
                                CollectionOptionView(title: "JEANS")
                                CollectionOptionView(title: "BOTTOMS")
                                CollectionOptionView(title: "ACTIVEWEAR")
                                CollectionOptionView(title: "SWIMWEAR")
                                CollectionOptionView(title: "PARTYWEAR")
                                CollectionOptionView(title: "OFFICEWEAR")
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchProducts { _, _ in }
        }
    }
}

struct CollectionOptionView: View {
    var title: String
    
    var body: some View {
        Button(action: {
            // Action when the option is clicked
        }) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        let cartItemsCount = Binding.constant(0) // Provide a mock binding for cartItemsCount
        return CollectionsView(cartItemsCount: cartItemsCount)
    }
}

