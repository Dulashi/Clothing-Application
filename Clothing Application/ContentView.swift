//
//  ContentView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-09.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedProducts: [Product] = []
    var body: some View {
       ProductListsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
