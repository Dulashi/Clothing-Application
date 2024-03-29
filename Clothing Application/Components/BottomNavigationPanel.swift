//
//  BottomNavigationPanel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-28.
//

import SwiftUI

struct BottomNavigationPanel: View {
    @State private var cartItemsCount: Int = 0
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(spacing: 0) {
                Divider()
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: HomeView()) {
                        ZStack(alignment: .top) {
                            Image(systemName: "house")
                                .padding()
                                .foregroundColor(.gray)
                            Text("Home")
                                .font(.caption)
                                .padding(.top, 38)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: AccountView()) {
                        ZStack(alignment: .top) {
                            Image(systemName: "person")
                                .padding()
                                .foregroundColor(.gray)
                            Text("Account")
                                .font(.caption)
                                .padding(.top, 38)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CollectionsView(cartItemsCount: $cartItemsCount)) {
                        ZStack(alignment: .top) {
                            Image(systemName: "square.grid.2x2")
                                .padding()
                                .foregroundColor(.gray)
                            Text("Collections")
                                .font(.caption)
                                .padding(.top, 38)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: WishlistView()) {
                        ZStack(alignment: .top) {
                            Image(systemName: "heart")
                                .padding()
                                .foregroundColor(.gray)
                            Text("Wishlist")
                                .font(.caption)
                                .padding(.top, 38)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct BottomNavigationPanel_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationPanel()
    }
}
