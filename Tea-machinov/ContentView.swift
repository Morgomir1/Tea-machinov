//
//  ContentView.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//


// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var currentScreen: AppScreen = .main
    
    enum AppScreen {
        case main, onboarding, tabs
    }
    
    var body: some View {
        switch currentScreen {
        case .main:
            MainScreen(goToOnboarding: {
                currentScreen = .onboarding
            })
        case .onboarding:
            OnboardingScreen(goToTabs: {
                currentScreen = .tabs
            })
        case .tabs:
            TabsScreen()
        }
    }
}
