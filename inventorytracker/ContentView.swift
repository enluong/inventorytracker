//
//  ContentView.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023
//
//  ContentView -- done checking

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct ContentView: View {
    
    // calls Firestore collection: inventory
    @FirestoreQuery(collectionPath: "inventory",
                    predicates: [.order(by: SortType.createdAt.rawValue, descending: true) ]
                    )
    // 'items' hold array of [InventoryItem] from collection of inventory
    private var items: [InventoryItem]
    
    // vm links to InventoryListViewModel class
    @StateObject private var vm = InventoryListViewModel()
    
    // what you see on iPad simulator
    var body: some View {
        VStack {
            // error if 'items' cannot be displayed due to data error in Firestore db
            if let error = $items.error {
                Text(error.localizedDescription)
            }
            
            // the order of what is being displayed
            List {
                // search bar
                InventorySearchView()
                
                // Sort by button
                sortBySectionView
                // items from db
                listItemsSectionView
            }
            // possibly the white box around each displaysbiv
        .listStyle(.insetGrouped)
        }
        
        // add 'items' button
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("+") { vm.addItem() }.font(.title)
            }
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
        }
        
        // sort by buttons
        .onChange(of: vm.selectedSortType) { _ in onSortTypeChanged() }
        .onChange(of: vm.isDescending) { _ in onSortTypeChanged() }
    }
    
    // how 'items' display information for each item detail
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
                            set: { vm.updateItem(item, data: ["location": $0]) }
                        ))
                    }
                    
                    // ITEM CABINET
                    HStack{
                        Text("Cabinet:")
                        TextField("Cabinet", text: Binding<String>(
                            get: { item.cabinet },
                            set: { vm.updateItem(item, data: ["cabinet": $0]) }
                        ))
                    }
                    
                    // ITEM NAME
                    HStack {
                        Text("Item Name:")
                        TextField("Name", text: Binding<String>(
                            get: { item.name },
                            set: { vm.updateItem(item, data: ["name": $0]) }
                        ))
                    }
                    
                    // ITEM QUANTITY
                    Stepper("Quantity: \(item.quantity)",
                            value: Binding<Int>(
                                get: { item.quantity },
                                set: { vm.updateItem(item, data: ["quantity": $0]) }),
                            in: 0...1000)
                    
                    // ITEM TYPE
                    HStack{
                        Text("Quantity Type:")
                        TextField("Type", text: Binding<String>(
                            get: { item.type },
                            set: { vm.updateItem(item, data: ["type": $0]) }
                        ))
                    }
                    
                }
            }
            // slide delete bar
            .onDelete { vm.onDelete(items: items, indexset: $0) }
        }
    }

 
    // sort by function
    private var sortBySectionView: some View {
        Section {
            DisclosureGroup("Sort by") {
                Picker("Sort by", selection: $vm.selectedSortType) {
                    ForEach(SortType.allCases, id: \.rawValue) { sortType in
                        Text(sortType.text).tag(sortType)
                    }
                }.pickerStyle(.segmented)
                
                Toggle("Is Descending", isOn: $vm.isDescending)
            }
        }
    }
    
    // sort by function
    private func onSortTypeChanged() {
        $items.predicates = vm.predicates
    }
}

// generates previews and so far we have ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InventorySearchView()
        ContentView()
    }
}
