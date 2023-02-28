//
//  EmailView.swift
//  inventorytracker
//
//  Created by John Dao  on 2/27/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift
import UIKit
import MessageUI

func sendEmail(to recipient: String, subject: String, body: String) {
    // Check if the device can send emails
    guard MFMailComposeViewController.canSendMail() else {
        print("Device can't send emails")
        return
    }

    // Create the mail composer view controller and set its properties
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.setToRecipients([recipient])
    mailComposerVC.setSubject(subject)
    mailComposerVC.setMessageBody(body, isHTML: false)

    // Present the mail composer view controller modally
    if let topViewController = UIApplication.shared.windows.first?.rootViewController {
        topViewController.present(mailComposerVC, animated: true, completion: nil)
    }
}

struct EmailView: View {
    
    // calls Firestore collection: inventory
    @FirestoreQuery(collectionPath: "inventory",
                    predicates: [.order(by: SortType.createdAt.rawValue, descending: true)])
    
    private var items: [InventoryItem]
    
    // holds the search query entered by the user
    @State private var searchText: String = ""
    
    // filtered items based on search query (This function searches all 0 quantity items)
    private var filteredItems: [InventoryItem] {
        if searchText.isEmpty {
            // return all items that have a quantity of 0
            return items.filter { $0.quantity == 0 }
        } else {
            // return items that match the search query and have a quantity of 0
            return items.filter { item in
                (item.name.localizedCaseInsensitiveContains(searchText) ||
                 item.location.localizedCaseInsensitiveContains(searchText) ||
                 item.cabinet.localizedCaseInsensitiveContains(searchText) ||
                 item.type.localizedCaseInsensitiveContains(searchText)) &&
                item.quantity == 0
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
            
            //Button on the bottom of the screen
            Button("Notify Supervisor", action: {
                let lowQuantityItems = items.filter { $0.quantity == 0 }
                let emailBody = "The following items are low in stock: \(lowQuantityItems.map { $0.name }.joined(separator: ", "))"
                sendEmail(to: "boupahrathandrew@gmail.com", subject: "Inventory Alert", body: emailBody)
            })
            .frame(width: 1000, height: 100) //adjust button size
            .foregroundColor(.white) //text color
            .background(Color.blue) //background color
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

