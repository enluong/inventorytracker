//
//  inventorytrackerApp.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023
//
//  UserAuthenticationApp - done checking 2

import FirebaseCore
import FirebaseFirestore
import Firebase
import SwiftUI
import UIKit

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
//            NavigationView {
            let item = InventoryListViewModel()
            ContentView()
            .environmentObject(item)
//            }
        }
    }
}
