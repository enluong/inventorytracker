//
//  inventorytrackerApp.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//
//  Modified by Team SEA 2023

import FirebaseCore
import FirebaseFirestore
import Firebase
import SwiftUI
import UIKit

// connects to cloud firestore
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct inventorytrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
//            NavigationView {
                ContentView()
//            }
        }
    }
}
