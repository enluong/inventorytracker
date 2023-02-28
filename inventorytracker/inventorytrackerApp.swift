//
//  inventorytrackerApp.swift
//  inventorytracker
//
//  Referencing Alfian Losari
//
//  by Team SEA 2023
//

import FirebaseCore
import FirebaseFirestore
import Firebase
import SwiftUI
import UIKit

// responsible for initializing and configuing app upon launch
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings
        Firestore.firestore().settings = settings
        return true
    }
    
}

@main
struct inventorytrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let item = InventoryListViewModel()
            ContentView()
                .environmentObject(item)
        }
    }
    
}
