//
//  InventorySearchView.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023
//
//  ProfileSearchView -- done checking 2

import SwiftUI

struct InventorySearchView: View {
    
    // placeholder for 'items' array but for a a singular 'item'
    @EnvironmentObject var item: InventoryListViewModel
    
    // itemLookup calls for file that fetches item from keyword search
    @StateObject var itemLookup = InventoryLookupViewModel()
    
    // keyword is just keyword sequence
    @State var keyword = ""
    
    // this is for actual search function on simulator/physical
    var body: some View {
        let keywordBinding = Binding<String>(
            get: {
                keyword
            },
            set: {
                keyword = $0
                itemLookup.fetchItem(with: keyword)
            }
        )
        VStack {
            SearchBarView(keyword: keywordBinding)
            ScrollView {
                ForEach(itemLookup.queryResultItems, id: \.id) { item in
                    InventoryBarView(item: item)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // stretches search bar
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
        
// design of search bar
struct SearchBarView: View {
    @Binding var keyword: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.5))
            HStack {
                TextField("Searching for...", text: $keyword)
                .autocapitalization(.none)
            }
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}

// design for actual search results
struct InventoryBarView: View {
    var item: InventoryItem
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.2))
            HStack {
                Text("\(item.location)")
                Spacer()
                Text("\(item.name)")
                Spacer()
                Text("\(item.quantity)")
                Spacer()
                Text("\(item.type)")
            }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .cornerRadius(13)
        .padding()
    }
}
    
