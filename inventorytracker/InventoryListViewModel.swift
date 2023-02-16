//
//  InventoryListViewModel.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023

import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

class InventoryListViewModel: ObservableObject {
    
    private let db = Firestore.firestore().collection("inventory")
    
    @Published var selectedSortType = SortType.createdAt
    @Published var isDescending = true
    @Published var editedItemName = ""
    @Published var editedItemLocation = ""
    @Published var editedItemType = ""
    
    var predicates: [QueryPredicate] { [.order(by: selectedSortType.rawValue, descending: isDescending)] }
    
    func addItem() {
        let item = InventoryItem(location: "Unknown", name: "New Item", quantity: 1, type:"Unknown")
        _ = try? db.addDocument(from: item)
    }
    
    func updateItem(_ item: InventoryItem, data: [String: Any]) {
        guard let id = item.id else { return }
        var _data = data
        _data["updatedAt"] = FieldValue.serverTimestamp()
        db.document(id).updateData(_data)
    }
    
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
}
