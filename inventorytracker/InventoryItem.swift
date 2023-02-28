//
//  InventoryItem.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023
//

import Foundation
import FirebaseFirestoreSwift

struct InventoryItem: Identifiable, Codable {
    
    // variable that holds documentID
    @DocumentID var id: String?
    
    // variables for InventoryItem details
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    
    var location: String
    var name: String
    var quantity: Int
    var type: String
    var cabinet: String
}
