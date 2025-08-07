//
//  ContentView.swift
//  LineaKit
//
//  Created by Роман Главацкий on 07.08.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                MainTabView()
                    .preferredColorScheme(dataManager.settings.isDarkMode ? .dark : .light)
                    .environmentObject(dataManager)
            } else {
                OnboardingView()
                    .preferredColorScheme(.dark)
                    .environmentObject(dataManager)
            }
        }
        .onAppear {
            // Force dark mode for modern design
            dataManager.settings.isDarkMode = true
        }
    }
}

#Preview {
    ContentView()
}
