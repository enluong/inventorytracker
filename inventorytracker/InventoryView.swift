//
//  InventoryView.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct InventoryView: View {
    
    // calls Firestore collection: inventory
    @FirestoreQuery(collectionPath: "inventory",
                    predicates: [.order(by: SortType.createdAt.rawValue, descending: true)])
    
    
    // 'items' hold array of [InventoryItem] from collection of inventory
    private var items: [InventoryItem]
    
    // listvm links to InventoryListViewModel class
    @StateObject private var listvm = InventoryListViewModel()
    
    // what you see on iPad simulator
    var body: some View {
        
        VStack {
            // the order of what is being displayed
            List {
                // Sort by button
                sortBySectionView
                // items from db
                listItemsSectionView
            }
            // possibly the white box around each displays
        .listStyle(.insetGrouped)
        }
        
        // 'items' button and 'edit' button
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("+") { listvm.addItem() }.font(.title)
            }
            ToolbarItem(placement: .bottomBar) { EditButton() }
        }
        
        // sort by buttons
        .onChange(of: listvm.selectedSortType) { _ in onSortTypeChanged() }
        .onChange(of: listvm.isDescending) { _ in onSortTypeChanged() }
    }
    
    
    // how 'items' display information on iPad for each item detail
    private var listItemsSectionView: some View {
        Section {
            // this is where 'items' turn into 'item' in order to display each item
            ForEach(items) { item in
                VStack {
                    // hstack keeps text and textfield next to each other
                    // ITEM LOCATION
                    HStack {
                        Text("Location:")
                        TextField("Location", text: Binding<String>(
                            get: { item.location },
                            set: { listvm.updateItem(item, data: ["location": $0]) }
                        ))
                    }
                    
                    // ITEM CABINET
                    HStack{
                        Text("Cabinet:")
                        TextField("Cabinet", text: Binding<String>(
                            get: { item.cabinet },
                            set: { listvm.updateItem(item, data: ["cabinet": $0]) }
                        ))
                    }
                    
                    // ITEM NAME
                    HStack {
                        Text("Item Name:")
                        TextField("Name", text: Binding<String>(
                            get: { item.name },
                            set: { listvm.updateItem(item, data: ["name": $0]) }
                        ))
                    }
                    
                    // ITEM QUANTITY
                    Stepper("Quantity: \(item.quantity)",
                            value: Binding<Int>(
                                get: { item.quantity },
                                set: { listvm.updateItem(item, data: ["quantity": $0]) }),
                            in: 0...1000)
                    
                    // ITEM TYPE
                    HStack{
                        Text("Quantity Type:")
                        TextField("Type", text: Binding<String>(
                            get: { item.type },
                            set: { listvm.updateItem(item, data: ["type": $0]) }
                        ))
                    }
                }
            }
            // delete function
            .onDelete { listvm.onDelete(items: items, indexset: $0) }
        }
    }

 
    // sort by function view
    private var sortBySectionView: some View {
        Section {
            DisclosureGroup("Sort by") {
                Picker("Sort by", selection: $listvm.selectedSortType) {
                    ForEach(SortType.allCases, id: \.rawValue) { sortType in
                        Text(sortType.text).tag(sortType)
                    }
                }.pickerStyle(.segmented)
                
                Toggle("Is Descending", isOn: $listvm.isDescending)
            }
        }
    }
    
    // sort by function
    private func onSortTypeChanged() {
        $items.predicates = listvm.predicates
    }
}

// idk what this is?
struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
//        InventorySearchView()
        ContentView()
    }
}
