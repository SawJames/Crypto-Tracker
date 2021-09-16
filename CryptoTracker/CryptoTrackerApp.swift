//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 15/09/2021.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
               HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
           
        }
    }
}
