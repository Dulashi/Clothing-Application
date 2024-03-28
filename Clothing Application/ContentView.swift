//
//  ContentView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-09.
//

//import SwiftUI
//
//struct ContentView: View {
//    @State private var cartItemsCount = 0 // Example state for cartItemsCount
//    
//    var body: some View {
//        CollectionsView(cartItemsCount: $cartItemsCount)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
import SwiftUI

struct ContentView: View {
    var body: some View {
        ProductListsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

