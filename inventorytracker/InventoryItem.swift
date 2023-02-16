//
//  InventoryItem.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//

import Foundation
import FirebaseFirestoreSwift

struct InventoryItem: Identifiable, Codable {
    
    @DocumentID var id: String?
    
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    
    var location: String
    var name: String
    var quantity: Int
    var type: String
    //var cabinet: String
}
