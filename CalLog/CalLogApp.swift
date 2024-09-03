//
//  CalLogApp.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI
import SwiftData

@main
struct CalLogApp: App {
    
    @StateObject private var myModel = MyModel()
    @AppStorage("onboarding") private var onboarding = true

    var body: some Scene {
        WindowGroup {
            if onboarding{
                OnboardingTabView(onboarding: $onboarding)
                    .environmentObject(myModel)
            }else{
                ContentView()
                    .environmentObject(myModel)
            }
        }
        .modelContainer(for: [WeightEntry.self, CalorieData.self, Food.self])
    }
}
