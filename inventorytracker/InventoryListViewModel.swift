//
//  InventoryListViewModel.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023
//

import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

class InventoryListViewModel: ObservableObject {
    
    private let db = Firestore.firestore().collection("inventory")
    
    // placeholder array for items that are being searched
    @Published var items: [InventoryItem] = []
    
    @Published var selectedSortType = SortType.createdAt
    @Published var isDescending = true
    
    // placeholder variables for editing
    @Published var editedItemName = ""
    @Published var editedItemLocation = ""
    @Published var editedItemType = ""
    @Published var editedItemCabinet = ""
    
    // idk
    var id: String?
    
    // for sort by function
    var predicates: [QueryPredicate] { [.order(by: selectedSortType.rawValue, descending: isDescending)] }
    
    // adding item in array InventoryItem
    func addItem() {
            // presets for InventoryItem details when add new item on iPad
            // * how to add data with empty keywords field?
            let item = InventoryItem(location: "Unknown", name: "New Item", quantity: 1, type:"Unknown", cabinet:"Unknown")
            
            // adds this new item into database
            _ = try? db.addDocument(from: item)
    }
    
    // update item in array InventoryItem
    func updateItem(_ item: InventoryItem, data: [String: Any]) {
        guard let id = item.id else { return }
        var _data = data
        _data["updatedAt"] = FieldValue.serverTimestamp()
        db.document(id).updateData(_data)
    }
    
    // deletes item in array InventoryItem
    func onDelete(items: [InventoryItem], indexset: IndexSet) {
        for index in indexset {
            guard let id = items[index].id else { continue }
            db.document(id).delete()
        }
    }
    
    // function when editing item location
    func onEditingItemLocationChanged(item: InventoryItem, isEditing: Bool) {
        if !isEditing && item.location != editedItemLocation {
            updateItem(item, data: ["location": editedItemLocation])
            editedItemLocation = ""
        } else {
            editedItemLocation = item.location
        }
    }
    
    // function when editing item name
    func onEditingItemNameChanged(item: InventoryItem, isEditing: Bool) {
        if !isEditing && item.name != editedItemName {
            updateItem(item, data: ["name": editedItemName])
            editedItemName = ""
        } else {
            editedItemName = item.name
        }
    }
    
    // function when editing item type
    func onEditingItemTypeChanged(item: InventoryItem, isEditing: Bool) {
        if !isEditing && item.type != editedItemType {
            updateItem(item, data: ["type": editedItemType])
            editedItemType = ""
        } else {
            editedItemType = item.type
        }
    }
    
    // SEARCH BAR STUFF ----------------- JUST HERE FOR NOW
    
    // function when editing item cabinet
    func onEditingItemCabinetChanged(item: InventoryItem, isEditing: Bool) {
        if !isEditing && item.cabinet != editedItemCabinet {
            updateItem(item, data: ["cabinet": editedItemCabinet])
            editedItemCabinet = ""
        } else {
            editedItemCabinet = item.cabinet
        }
    }
    
    // for search bar stuff
    func searchItems(query: String) {
        let collectionRef = Firestore.firestore().collection("inventory")
        let queryRef = collectionRef.whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .whereField("cabinet", isGreaterThanOrEqualTo: query)
            .whereField("cabinet", isLessThanOrEqualTo: query + "\u{f8ff}")
            .whereField("location", isGreaterThanOrEqualTo: query)
            .whereField("location", isLessThanOrEqualTo: query + "\u{f8ff}")
            .whereField("type", isGreaterThanOrEqualTo: query)
            .whereField("type", isLessThanOrEqualTo: query + "\u{f8ff}")
        queryRef.getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error searching items: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No matching documents.")
                return
            }
            let items = documents.compactMap { queryDocumentSnapshot -> InventoryItem? in
                try? queryDocumentSnapshot.data(as: InventoryItem.self)
            }
            DispatchQueue.main.async {
                self.items = items
            }
        }
    }

    func loadItems() {
        // Retrieve the items from the Firestore database
        db.getDocuments { (querySnapshot, error) in
            // Check for errors
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            // Parse the query snapshot into an array of InventoryItem objects
            let items = querySnapshot!.documents.compactMap { document in
                try? document.data(as: InventoryItem.self)
            }
            
            // Sort the items according to the selected sort type and direction
//            let sortedItems = items.sorted(by: selectedSortType.sortDescriptor(isDescending: isDescending))
            
            // Update the @Published items property
            self.items = items
        }
    }
    
}
