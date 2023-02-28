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
                    Text("List of all inventory items")
                }
            InventorySearchView()
                .tabItem {
                    Text("Search inventory items")
                }
            // uncomment these for email tab
//            EmailView()
//                .tabItem {
//                    Text("Email")
//                }
        }
    }
}
    
    // generates previews?
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

