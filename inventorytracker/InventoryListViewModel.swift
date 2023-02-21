//
//  InventoryListViewModel.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023
//
// UserViewModel

import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

class InventoryListViewModel: ObservableObject {
    
    private let db = Firestore.firestore().collection("inventory")
    
    // placeholder array for items that are being searched
    @Published var queryResultItems: [InventoryItem] = []
    
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
        let item = InventoryItem(location: "Unknown", name: "New Item", quantity: 1, type:"Unknown", cabinet:"Unknown")
        _ = try? db.addDocument(from: item)
        
        // supposed to add the new keywords according to new item
        db.document().updateData(["keywordsForLookup": item.keywordsForLookup])
    }
    
    // update item in array InventoryItem
    func updateItem(_ item: InventoryItem, data: [String: Any]) {
        guard let id = item.id else { return }
        var _data = data
        _data["updatedAt"] = FieldValue.serverTimestamp()
        db.document(id).updateData(_data)
        
        // supposed to update keywords according to update item
        db.document().updateData(["keywordsForLookup": item.keywordsForLookup])
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
    
    // function when editing item cabinet
    func onEditingItemCabinetChanged(item: InventoryItem, isEditing: Bool) {
        if !isEditing && item.cabinet != editedItemCabinet {
            updateItem(item, data: ["cabinet": editedItemCabinet])
            editedItemCabinet = ""
        } else {
            editedItemCabinet = item.cabinet
        }
    }
}
        
    


        
    

