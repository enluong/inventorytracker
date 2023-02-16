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
 //       let document = db.collection("InventoryItem").document(InventoryItem(name: <#T##String#>, quantity: <#T##Int#>))
 //       try document.setData(from: InventoryItem)
 //       item.updateItem(["keywordsForLookup": InventoryItem.keywordsForLookup])
    }
    
//    func updateItem(_ item: InventoryItem, data: [String: Any]) {
//        guard let id = item.id else { return }
//        var _data = data
//        _data["updatedAt"] = FieldValue.serverTimestamp()
//        db.document(id).updateData(_data)
//    }
    
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
    
//    func onEditingItemNameChanged(item: InventoryItem, isEditing: Bool) {
//        if !isEditing {
//            if item.name != editedName {
//                updateItem(item, data: ["name": editedName])
//            }
//            editedName = ""
//        } else {
//            editedName = item.name
//        }
//    }
    
//    func onEditingItemNameChanged(item: InventoryItem, isEditing: Bool) {
//        if !isEditing {
//            if item.name != editedName {
//                updateItem(item, data: ["name": editedName])
//            }
//            editedName = ""
//        } else {
//            editedName = item.name
//        }
//    }

    var debounceTimer: Timer?
    
    // function when editing item location
    func onEditingItemLocationChanged(item: InventoryItem, isEditing: Bool) {
        if debounceTimer != nil {
            debounceTimer?.invalidate()
            debounceTimer = nil
        }
        if !isEditing {
            if item.location != editedItemLocation {
                updateItem(item, data: ["location": editedItemLocation])
            }
            editedItemLocation = "location"
        } else {
            editedItemLocation = item.location
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if item.location != self.editedItemLocation {
                    self.updateItem(item, data: ["location": self.editedItemLocation])
                }
                self.editedItemLocation = ""
                self.debounceTimer = nil
            }
        }
    }

    // function when editing item name
    func onEditingItemNameChanged(item: InventoryItem, isEditing: Bool) {
        if debounceTimer != nil {
            debounceTimer?.invalidate()
            debounceTimer = nil
        }
        if !isEditing {
            if item.name != editedItemName {
                updateItem(item, data: ["name": editedItemName])
            }
            editedItemName = "name"
        } else {
            editedItemName = item.name
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if item.name != self.editedItemName {
                    self.updateItem(item, data: ["name": self.editedItemName])
                }
                self.editedItemName = ""
                self.debounceTimer = nil
            }
        }
    }
    
    // function when editing item type
    func onEditingItemTypeChanged(item: InventoryItem, isEditing: Bool) {
        if debounceTimer != nil {
            debounceTimer?.invalidate()
            debounceTimer = nil
        }
        if !isEditing {
            if item.type != editedItemType {
                updateItem(item, data: ["type": editedItemType])
            }
            editedItemType = "type"
        } else {
            editedItemType = item.type
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if item.type != self.editedItemType {
                    self.updateItem(item, data: ["type": self.editedItemType])
                }
                self.editedItemType = ""
                self.debounceTimer = nil
            }
        }
    }
}

