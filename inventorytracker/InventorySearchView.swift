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
    
    // holds the search query entered by the user
    @State private var searchText: String = ""
    
    // filtered items based on search query
        private var filteredItems: [InventoryItem] {
            if searchText.isEmpty {
                return items
            } else {
                return items.filter { item in
                    return item.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    
    // what you see on iPad simulator
    var body: some View {
        VStack {
            // search bar
            InventorySearchBar(searchText: $searchText)
                .padding(.top, 8)
            
            // the order of what is being displayed
            List {
                // items from db
                listItemsSectionView
            }
            // possibly the white box around each displays
            .listStyle(.insetGrouped)
        }
    }
    
    // how 'items' display information on iPad for each item detail
    private var listItemsSectionView: some View {
        Section {
            // this is where 'items' turn into 'item' in order to display each item
            ForEach(filteredItems) { item in
                VStack {
                    // hstack keeps text and textfield next to each other
                    // ITEM LOCATION
                    HStack {
                        Text("Location:")
                        TextField("Location", text: Binding<String>(
                            get: { item.location },
                            set: { updateItem(item, data: ["location": $0]) }
                        ))
                    }
                    
                    // ITEM CABINET
                    HStack{
                        Text("Cabinet:")
                        TextField("Cabinet", text: Binding<String>(
                            get: { item.cabinet },
                            set: { updateItem(item, data: ["cabinet": $0]) }
                        ))
                    }
                    
                    // ITEM NAME
                    HStack {
                        Text("Item Name:")
                        TextField("Name", text: Binding<String>(
                            get: { item.name },
                            set: { updateItem(item, data: ["name": $0]) }
                        ))
                    }
                    
                    // ITEM QUANTITY
                    Stepper("Quantity: \(item.quantity)",
                            value: Binding<Int>(
                                get: { item.quantity },
                                set: { updateItem(item, data: ["quantity": $0]) }),
                            in: 0...1000)
                    
                    // ITEM TYPE
                    HStack{
                        Text("Quantity Type:")
                        TextField("Type", text: Binding<String>(
                            get: { item.type },
                            set: { updateItem(item, data: ["type": $0]) }
                        ))
                    }
                }
            }
        }
    }
    
    // update item in array InventoryItem
    func updateItem(_ item: InventoryItem, data: [String: Any]) {
        let db = Firestore.firestore().collection("inventory")
        guard let id = item.id else { return }
        var _data = data
        _data["updatedAt"] = FieldValue.serverTimestamp()
        db.document(id).updateData(_data)
    }
}
