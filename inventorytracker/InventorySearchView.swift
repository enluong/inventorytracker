//
//  ProfileView.swift
//  inventorytracker
//
//  Created by Erin on 2/15/23.
//

import SwiftUI

struct InventorySearchView: View {
    @EnvironmentObject var item: InventoryListViewModel
    @StateObject var itemLookup = InventoryLookupViewModel()
    @State var keyword = ""
    
    var body: some View {
        let keywordBinding = Binding<String>(
            get: {
                keyword
            },
            set: {
                keyword = $0
                itemLookup.fetchItem(from: keyword)
            }
        )
        VStack {
            SearchBarView(keyword: keywordBinding)
            ScrollView {
                ForEach(itemLookup.queriedItem, id: \.name) { user in
//                    ProfileBarView(item: InventoryItem)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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

//struct ProfileBarView: View {
//    var item: InventoryItem
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//            .foregroundColor(Color.gray.opacity(0.2))
//            HStack {
//                Text("\(item.name)")
//                Spacer()
//                Text("\(item.quantity) \(item.type)")
//            }
//            .padding(.horizontal, 10)
//        }
//        .frame(maxWidth: .infinity, minHeight: 100)
//        .cornerRadius(13)
//        .padding()
//    }
//}
