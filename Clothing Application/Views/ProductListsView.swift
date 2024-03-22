//
//  ProductListsView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import SwiftUI

struct ProductListsView: View {
    @StateObject var viewModel = ProductViewModel()
    
    var body: some View {
        List(viewModel.products, id: \.name) { (product: Product) in
            VStack(alignment: .leading){
                    
                    Text(product.name)
                        .font(.headline)
                    Text(product.description)
                        .font(.subheadline)
                    Text("$\(product.price)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    Text("Sizes: \(product.sizes.joined(separator: ", "))")
                        .font(.subheadline)
                    
                    Text("Colors: \(product.colors.joined(separator: ", "))")
                        .font(.subheadline)
                    
                    ForEach(product.images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .onAppear {
                viewModel.fetchProducts { _, _ in }
            }
        }
    }

    
    struct ProductListsView_Previews: PreviewProvider {
        static var previews: some View {
            ProductListsView()
        }
    }

