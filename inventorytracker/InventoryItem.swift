//
//  InventoryItem.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023
//
//  User - done checking

import Foundation
import FirebaseFirestoreSwift

struct InventoryItem: Identifiable, Codable {
    
    // reference to uuid from search bar YT video
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
    
    // for search bar: generates keywords for each InventoryItem detail
    var keywordsForLookup: [String] {
        [self.name.generateStringSequence(), self.location.generateStringSequence(), self.type.generateStringSequence(), self.cabinet.generateStringSequence()].flatMap { $0 }
    }
    
}

// for search bar: generates string seqeuences ex: 'Item' -> 'I', 'It', 'Ite', 'Item'
extension String {
    func generateStringSequence() -> [String] {
        guard self.count > 0 else { return [] }
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)))
        }
        return sequences
    }
}

