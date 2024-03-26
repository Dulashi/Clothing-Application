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
    
    var body: some View {
        NavigationView { // Wrap content in NavigationView
            ScrollView {
                VStack {
                    // Header
                    HStack {
                        Button(action: {
                            // Handle back button action
                        }) {
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
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingSortOptions.toggle()
                        }) {
                            Text("Sort | Filter")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    
                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.products, id: \.name) { product in
                            ProductItemView(product: product, cartItemsCount: $cartItemsCount, selectedProducts: $selectedProducts)
// Pass cartItemsCount and selectedProducts
                        }
                    }
                    .padding()
                    .onAppear {
                        viewModel.fetchProducts { _, _ in }
                    }
                }
                .sheet(isPresented: $isShowingSortOptions, content: {
                    SortOptionsView()
                })
            }
        }
    }
}

struct ProductItemView: View {
    let product: Product
    @Binding var cartItemsCount: Int
    @State private var imageData: Data? = nil
    @State private var isShowingDetail = false // Add state to control detail view presentation
    @Binding var selectedProducts: [Product]
    @State private var isShowingPopup = false
  
    
    var body: some View {
        VStack {
            // Product image or placeholder
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(30)
                    .overlay(
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
                        .offset(x: -40, y: 0),
                        alignment: .topTrailing
                    )
                    .onTapGesture {
                        isShowingDetail = true // Present detail view when tapped
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
                //   .foregroundColor(.black)
                // .offset(x: 60, y: -20);
            }
            .frame(width: 170)
            .padding(.vertical, 5)
            .background(Color.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isShowingDetail) {
            ProductDetailView(product: product) // Present detail view with selected product
        }
        .sheet(isPresented: $isShowingPopup) {
            ProductSelectionPopup(product: product, cartItemsCount: $cartItemsCount, selectedProducts: $selectedProducts)
        }
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
    
