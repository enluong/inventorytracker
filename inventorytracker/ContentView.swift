//
//  ContentView.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct ContentView: View {
    
    @FirestoreQuery(collectionPath: "inventory",
                    predicates: [.order(by: SortType.createdAt.rawValue, descending: true) ]
    ) private var items: [InventoryItem]
    @StateObject private var vm = InventoryListViewModel()
    
    var body: some View {
        VStack {
//            InventorySearchView()
            
            if let error = $items.error {
                Text(error.localizedDescription)
            }
            
            List {
                sortBySectionView
                listItemsSectionView
            }
            .listStyle(.insetGrouped)
            
        }
        // add item button
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("+") { vm.addItem() }.font(.title)
            }
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
        }
        
        // sort by buttons
        .onChange(of: vm.selectedSortType) { _ in onSortTypeChanged() }
        .onChange(of: vm.isDescending) { _ in onSortTypeChanged() }
//        .navigationTitle("CSI Inventory")
    }
    
    private var listItemsSectionView: some View {
        Section {
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
            .onDelete { vm.onDelete(items: items, indexset: $0) }
        }
    }
    
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
    
    private func onSortTypeChanged() {
        $items.predicates = vm.predicates
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

