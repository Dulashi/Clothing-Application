//
//  ProductListsView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import SwiftUI

struct ProductListsView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var isShowingSortOptions = false
    @State private var cartItemsCount = 0 // State to track cart items count
    @State private var selectedProducts: [Product] = [] // State to track selected products
    @State private var password = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        // Header
                        HStack {
                            NavigationLink(destination: CollectionsView(cartItemsCount: $cartItemsCount)) {
                                Image(systemName: "chevron.left")
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("DRESSES")
                                .font(.title)
                                .fontWeight(.medium)
                            Spacer()
                            NavigationLink(destination: ShoppingCartView(selectedProducts: $selectedProducts)) {
                                ZStack {
                                    Image(systemName: "cart")
                                        .padding()
                                        .foregroundColor(.gray)
                                    if cartItemsCount > 0 { // Show cart items count if greater than 0
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
                        
                        Button(action: {
                            isShowingSortOptions.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.1))
                                    .frame(height: 40)
                                    .cornerRadius(10)
                                
                                HStack {
                                    Spacer()
                                    Text("Sort & Filter")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)

                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.products, id: \.name) { product in
                                ProductItemView(product: product, cartItemsCount: $cartItemsCount, selectedProducts: $selectedProducts)
                            }
                        }
                        .padding()
                        .onAppear {
                            viewModel.fetchProducts { _, _ in }
                        }
                    }
                }
                
                BottomNavigationPanel(email: email, password: password)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingSortOptions) {
            SortOptionsView()
        }
    }
}

struct ProductItemView: View {
    let product: Product
    @Binding var cartItemsCount: Int
    @State private var imageData: Data? = nil
    @State private var isShowingDetail = false
    @Binding var selectedProducts: [Product]
    @State private var isShowingPopup = false
    @State private var isWishlisted = false // New state to track wishlist status
    
    var body: some View {
        VStack {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                ZStack(alignment: .bottomLeading) { // Stack for image and buttons
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .cornerRadius(30)
                        .onTapGesture {
                            isShowingDetail = true // Present detail view when tapped
                        }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingPopup = true
                        }) {
                            Image(systemName: "plus")
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.8))
                                .clipShape(Circle())
                                .padding(8)
                        }
                        .offset(x: 150, y: -190)
                        
                        HStack {
                            Spacer()
                            VStack { // ContentView for heart button
                                Button(action: {
                                    isWishlisted.toggle()
                                    if isWishlisted {
                                        // Add product to wishlist
                                        saveToWishlist()
                                    } else {
                                        // Remove product from wishlist
                                        removeFromWishlist()
                                    }
                                }) {
                                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                                        .foregroundColor(isWishlisted ? .white: .black)
                                        .padding(20)
                                        .clipShape(Circle())
                                        .font(.system(size: 23))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .offset(x: 10, y: -1)
                            
                            
                            .offset(x: 20, y: 10)
                            .background(Color.clear)
                            
                        }
                    }
                }
            } else {
                Color.gray
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .onAppear {
                        loadImage()
                    }
                    .onTapGesture {
                        isShowingDetail = true // Present detail view when tapped
                    }
            }
            
            // Product details
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .padding(.horizontal, 5)
                
                Text("LKR \(String(format: "%.2f", product.price))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
            }
            
            Button(action: {
                // Action when heart button is tapped
            }) {
                // Image(systemName: "heart")
                //  .foregroundColor(.black)
                // .offset(x: 60, y: -20);
            }
            .frame(width: 170)
            .padding(.vertical, 5)
            .background(Color.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isShowingDetail) {
            ProductDetailView(product: product, selectedProducts: $selectedProducts, cartItemsCount: $cartItemsCount)
        }
        
        .sheet(isPresented: $isShowingPopup) {
            ProductSelectionPopup(product: product, cartItemsCount: $cartItemsCount, selectedProducts: $selectedProducts)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadImage() {
        guard let firstImageUrl = product.imageUrls.first,
              let url = URL(string: firstImageUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
    
    private func saveToWishlist() {
        WishlistManager.shared.addToWishlist(name: product.name, price: product.price, imageUrls: product.imageUrls)
    }
    
    private func removeFromWishlist() {
        WishlistManager.shared.removeFromWishlist(product.name)
    }
    
}



struct ProductSelectionPopup: View {
    let product: Product
    @Binding var cartItemsCount: Int
    @Binding var selectedProducts: [Product]
    @State private var selectedSize: String?
    @State private var selectedColor: String?
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack {
            VStack {
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                } else {
                    Color.gray
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                }
                
                // Product name and price
                Text(product.name)
                    .font(.caption)
                    .padding(.top, 5)
                Text("LKR \(String(format: "%.2f", product.price))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .onAppear {
                loadImage()
            }
            
            // Select size
            VStack(alignment: .leading, spacing: 10) {
                Text("Select Size:")
                    .font(.headline)
                    .padding(.horizontal)
                
                // Buttons for sizes
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(product.sizes, id: \.self) { size in
                            Button(action: {
                                selectedSize = size
                            }) {
                                Text(size)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(selectedSize == size ? Color.black : Color.gray.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Select color
            VStack(alignment: .leading, spacing: 10) {
                Text("Select Color:")
                    .font(.headline)
                    .padding(.horizontal)
                
                // Buttons for colors
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(product.colors, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                            }) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(color))
                                        .frame(width: 30, height: 30)
                                    
                                    Text(color) // Display color names inside oval shapes
                                        .foregroundColor(.black)
                                        .font(.caption)
                                }
                            }
                            .padding(5)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Add to Cart Button
            Button(action: {
                // Add the selected product to the cart
                if let selectedSize = selectedSize, let selectedColor = selectedColor {
                    let selectedProduct = Product(name: product.name,  category:"", price: product.price, sizes: [selectedSize], colors: [selectedColor], description: "",imageUrls: product.imageUrls, available: Bool())
                    cartItemsCount += 1
                    selectedProducts.append(selectedProduct)
                }
            }) {
                Text("Add to Cart")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5)
    }
    
    private func loadImage() {
        guard let firstImageUrl = product.imageUrls.first,
              let url = URL(string: firstImageUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
}

    struct SortOptionsView: View {
        var body: some View {
            VStack {
                Text("Sort by:")
                    .font(.headline)
                    .padding(.bottom)
                
                Button(action: {
                    // Action when "Featured" is selected
                }) {
                    HStack {
                        Text("Featured")
                            .foregroundColor(.black)
                        Spacer()
                        if isSelected("Featured") {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                Button(action: {
                    // Action when "Newest" is selected
                }) {
                    HStack {
                        Text("Newest")
                            .foregroundColor(.black)
                        Spacer()
                        if isSelected("Newest") {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                Button(action: {
                    // Action when "Best Selling" is selected
                }) {
                    HStack {
                        Text("Best Selling")
                            .foregroundColor(.black)
                        Spacer()
                        if isSelected("Best Selling") {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                Button(action: {
                    // Action when "Price: Low to High" is selected
                }) {
                    HStack {
                        Text("Price: Low to High")
                            .foregroundColor(.black)
                        Spacer()
                        if isSelected("Price: Low to High") {
                            Image(systemName: "checkmark")
                            
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                Button(action: {
                    // Action when "Price: High to Low" is selected
                }) {
                    HStack {
                        Text("Price: High to Low")
                            .foregroundColor(.black)
                        Spacer()
                        if isSelected("Price: High to Low") {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                Button(action: {
                    // Apply selected sort option
                }) {
                    Text("Apply")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(10))
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding()
            .shadow(radius: 5)
        }
        
        private func isSelected(_ option: String) -> Bool {
            // Implement logic to check if option is selected
            return false
        }
    }
    

