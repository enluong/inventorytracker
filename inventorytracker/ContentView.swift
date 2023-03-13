//
//  ContentView.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            InventoryView()
                .tabItem {
                    Image(systemName: "house")
                    Text("List of all inventory items")
                }
            InventorySearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search inventory items")
                }
            EmailView()
                .tabItem {
                    Image(systemName: "mail")
                    Text("Email Low inventory stocks")
                }
        }
    }
}
    
    // generates previews?
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
