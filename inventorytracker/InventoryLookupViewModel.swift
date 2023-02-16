//
//  ItemsLookupViewModel.swift
//  inventorytracker
//
//  Created by Erin on 2/15/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class InventoryLookupViewModel: ObservableObject {
    
    @Published var queriedItem: [InventoryItem] = []
    
    private let db = Firestore.firestore()
    
    func fetchItem(from keyword: String){
        db.collection("inventory").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in guard let documents = querySnapshot?.documents, error == nil else { return }
            self.queriedItem = documents.compactMap { QueryDocumentSnapshot in
                try? QueryDocumentSnapshot.data(as: InventoryItem.self)
            }
        }
    }
}
