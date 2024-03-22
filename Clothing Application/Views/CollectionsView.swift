//
//  CollectionsView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import SwiftUI

struct CollectionsView: View {
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
                        TextField("Search Products", text: .constant(""))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .foregroundColor(.black)
                    }
                    .background(Color.gray.opacity(0))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
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
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.red.opacity(0.2))
        .cornerRadius(10)
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}

#Preview {
    CollectionsView()
}
