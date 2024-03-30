//
//  HomeView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-28.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var cartItemsCount = 0
    @State private var selectedProducts: [Product] = []
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var searchSuggestions: [Product] = []
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            NavigationLink(destination: CollectionsView(cartItemsCount: $cartItemsCount)) {
                                Image(systemName: "line.horizontal.3")
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("GlamCloth")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: ShoppingCartView(selectedProducts: $selectedProducts)) {
                                ZStack {
                                    Image(systemName: "cart")
                                        .padding()
                                        .foregroundColor(.gray)
                                    if cartItemsCount > 0 {
                                        Text("\(cartItemsCount)")
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                            .background(Color.black)
                                            .clipShape(Circle())
                                            .offset(x: 10, y: -10)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Text("Clothing company")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, -30)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                                .padding(.leading, 5)
                            TextField("Search Products", text: $searchText)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                                .onChange(of: searchText) { newValue in
                                    filterProducts()
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                        

                        if isSearching {
                            ForEach(searchSuggestions, id: \.id) { product in
                                NavigationLink(destination: ProductDetailView(product: product, selectedProducts: $selectedProducts, cartItemsCount: $cartItemsCount)) {
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
                            .listStyle(PlainListStyle())
                        }
                        Image("banner1_home")
                            .resizable()
                             .scaledToFit()
                               .padding([.horizontal, .bottom], 5)
                                                                                         
                                 Text("New Arrivals")
                                  .font(.title)
                                    .fontWeight(.bold)
                                     .padding(.bottom, 5)
                                                                                         
                                        let productsSlice = viewModel.products.prefix(4)
                                                                                         
                                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                            ForEach(productsSlice, id: \.name) { product in
                                                    ProductItemView(product: product, cartItemsCount: $cartItemsCount, selectedProducts: $selectedProducts)
                                                                        }
                                                                    }
                                                            .padding()
                                                             .onAppear {
                                                                viewModel.fetchProducts { _, _ in }
                                                                                }
                                                                                         
                                                                        Image("banner2_home")
                                                                            .resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                                        .padding()
                                                                                         
                                                                                         HStack(alignment: .center) {
                                                                                             Image("facebook")
                                                                                                 .resizable()
                                                                                                 .aspectRatio(contentMode: .fit)
                                                                                                 .frame(width: 20, height: 20)
                                                                                             Text("FOLLOW US ON FACEBOOK")
                                                                                                 .font(.system(size: 14, weight: .bold))
                                                                                                 .foregroundColor(.gray)
                                                                                         }
                                                                                         
                                                                                         Spacer()
                                                                                         Spacer()
                                                                                         
                                                                                         
                                                                                         HStack(alignment: .center) {
                                                                                             Image("instagram")
                                                                                                 .resizable()
                                                                                                 .aspectRatio(contentMode: .fit)
                                                                                                 .frame(width: 20, height: 20)
                                                                                             Text("FOLLOW US ON INSTAGRAM")
                                                                                                 .font(.system(size: 14, weight: .bold))
                                                                                                 .foregroundColor(.gray)
                                                                                         }
                                                                                         
                                                                                         Spacer()
                                                                                         Spacer()
                                                                                         
                                                                                         HStack(alignment: .center) {
                                                                                             Image("twitter")
                                                                                                 .resizable()
                                                                                                 .aspectRatio(contentMode: .fit)
                                                                                                 .frame(width: 20, height: 20)
                                                                                             Text("FOLLOW US ON TWITTER")
                                                                                                 .font(.system(size: 14, weight: .bold))
                                                                                                 .foregroundColor(.gray)
                                                                                         }
                                                                                         
                                                                                         Spacer()
                                                                                         Spacer()
                                                                                         
                                                                                         HStack(alignment: .center) {
                                                                                             Image("snapchat")
                                                                                                 .resizable()
                                                                                                 .aspectRatio(contentMode: .fit)
                                                                                                 .frame(width: 20, height: 20)
                                                                                             Text("FOLLOW US ON SNAPCHAT")
                                                                                                 .font(.system(size: 14, weight: .bold))
                                                                                                 .foregroundColor(.gray)
                                                                                         }
                                                                                         
                                                                                         Spacer()
                                                                                         Spacer()
                                                                                         
                                                                                         HStack(alignment: .center) {
                                                                                             Image("pinterest")
                                                                                                 .resizable()
                                                                                                 .aspectRatio(contentMode: .fit)
                                                                                                 .frame(width: 20, height: 20)
                                                                                             Text("FOLLOW US ON PINTEREST")
                                                                                                 .font(.system(size: 14, weight: .bold))
                                                                                                 .foregroundColor(.gray)
                                                                                         }
                                                                                         Spacer()
                                                                                         Spacer()
                                                                                        
                                                                                         
                                                                                         VStack {
                                                                                             
                                                                                             ZStack {
                                                                                                 Rectangle()
                                                                                                     .foregroundColor(.black)
                                                                                                     .frame(height: 20)
                                                                                                 Text("CONTACT US")
                                                                                                     .font(.system(size: 14, weight: .bold))
                                                                                                     .foregroundColor(.white)
                                                                                             }
                                                                                             
                                                                                             Spacer()
                                                                                             
                                                                                            
                                                                                             ZStack {
                                                                                                 Rectangle()
                                                                                                     .foregroundColor(.black)
                                                                                                     .frame(height: 20)
                                                                                                 Text("FAQ")
                                                                                                     .font(.system(size: 14, weight: .bold))
                                                                                                     .foregroundColor(.white)
                                                                                             }
                                                                                             
                                                                                             Spacer()
                                                                                             
                                                                                             
                                                                                             ZStack {
                                                                                                 Rectangle()
                                                                                                     .foregroundColor(.black)
                                                                                                     .frame(height: 20)
                                                                                                 Text("SHIPPING & RETURNS")
                                                                                                     .font(.system(size: 14, weight: .bold))
                                                                                                     .foregroundColor(.white)
                                                                                             }
                                                                                             
                                                                                             Spacer()
                                                                                             
                                                                                 
                                                                                             ZStack {
                                                                                                 Rectangle()
                                                                                                     .foregroundColor(.black)
                                                                                                     .frame(height: 20)
                                                                                                 Text("SIZING CHART")
                                                                                                     .font(.system(size: 14, weight: .bold))
                                                                                                     .foregroundColor(.white)
                                                                                             }
                                                                                         }
                    
                    }
                }
                .onAppear {
                    viewModel.fetchProducts { _, _ in
                        print("Products fetched:", viewModel.products)
                    }
                }
                .onChange(of: searchText) { newValue in
                    print("Search text changed:", newValue)
                    filterProducts()
                }
                
                BottomNavigationPanel(email: email, password: password)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func filterProducts() {
        if searchText.isEmpty {
            isSearching = false
            searchSuggestions.removeAll()
        } else {
            isSearching = true
            searchSuggestions = viewModel.products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            print("Search suggestions:", searchSuggestions) // Check search suggestions
        }
    }
}
