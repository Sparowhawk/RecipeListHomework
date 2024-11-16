//
//  RecipeApp.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/13/24.
//

import SwiftUI
import SwiftData

@main
struct RecipeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appdelegate
        
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
}
