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
    @State private var selectedProduct: Product? = nil
    @State private var selectedProducts: [Product] = []
    @State private var navigateToProductLists = false
    @Binding var cartItemsCount: Int
    
    let email: String
    let password: String
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Button(action: {
                           
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .foregroundColor(.gray)
                                .padding()
                        }
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
                    
                    if isSearching && !filteredProducts.isEmpty {
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                ForEach(filteredProducts) { product in
                                    NavigationLink(
                                        destination: ProductDetailView(product: product, selectedProducts: $selectedProducts, cartItemsCount: $cartItemsCount),
                                        label: {
                                            HStack {
                                                Text(product.name)
                                                    .foregroundColor(.black)
                                                    .lineLimit(3)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.gray)
                                            }
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    } else {
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                CollectionOptionView(title: "NEW ARRIVALS")
                                CollectionOptionView(title: "DRESSES")
                                    .onTapGesture {
                                        navigateToProductLists = true
                                    }
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
        .background(
            NavigationLink(
                destination: ProductListsView(viewModel: viewModel),
                isActive: $navigateToProductLists,
                label: { EmptyView() }
            )
        )
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        if !navigateToProductLists {
            BottomNavigationPanel(selectedProducts: $selectedProducts ,email: email, password: password)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return []
        } else {
            return viewModel.products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    
    struct CollectionOptionView: View {
        var title: String
        @State private var isActive = false
        
        var body: some View {
            NavigationLink(
                destination: ProductListsView(),
                isActive: $isActive,
                label: {
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
                })
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .onTapGesture {
                isActive = true
            }
        }
    }
    
    struct CollectionsView_Previews: PreviewProvider {
        static var previews: some View {
            let email = ""
            let password = ""
            let cartItemsCount = Binding.constant(0) 
            return CollectionsView(cartItemsCount: cartItemsCount, email: email, password: password)
        }
    }
}

#Preview {
    CollectionsView(cartItemsCount: .constant(0), email: "", password: "")
}
