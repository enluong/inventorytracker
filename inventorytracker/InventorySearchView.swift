//
//  InventorySearchView.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023
//

import SwiftUI
import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

struct InventorySearchBar: UIViewRepresentable {
    
    @Binding var searchText: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var searchText: String
        
        init(searchText: Binding<String>) {
            _searchText = searchText
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
        }
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchText
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(searchText: $searchText)
    }
}

struct InventorySearchView: View {
    
    // calls Firestore collection: inventory
    @FirestoreQuery(collectionPath: "inventory",
                    predicates: [.order(by: SortType.createdAt.rawValue, descending: true)])
    
    private var items: [InventoryItem]
    
    // listvm links to InventoryListViewModel class
    @StateObject private var listvm = InventoryListViewModel()
    
    // holds the search query entered by the user
    @State private var searchText = ""
    
    // what you see on iPad simulator
    var body: some View {
        VStack {
            InventorySearchBar(searchText: $searchText)
            
            // error if 'items' cannot be displayed due to data error in Firestore db
            if let error = $items.error {
                Text(error.localizedDescription)
            }
        }
    }
}
