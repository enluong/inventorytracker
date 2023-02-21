//
//  ItemsLookupViewModel.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023
//
//  UsersLookupViewModel -- done checking

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class InventoryLookupViewModel: ObservableObject {
    
    // calls array InventoryItem, but makes empty array of quriedItem
//    @Published var queriedItem: [InventoryItem] = []
    @Published var queryResultItems: [InventoryItem] = []
    
    // db variable is for calling Firestore
    private let db = Firestore.firestore()
    
    // fetches item from keyword
    func fetchItem(with keyword: String){
        db.collection("inventory").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in guard let documents = querySnapshot?.documents, error == nil else { return }
            
            self.queryResultItems = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: InventoryItem.self)
            }
        }
    }
}
