//
//  SortType.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023

import Foundation

enum SortType: String, CaseIterable {
    
    case createdAt
    case updatedAt
    case name
    case quantity
    
    // displays InventoryItem on iPad from database
    var text: String {
        switch self {
        case .createdAt: return "Created At"
        case .updatedAt: return "Updated At"
        case .name: return "Name"
        case .quantity: return "Quantity"
        }
    }
    
}
