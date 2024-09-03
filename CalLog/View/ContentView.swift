//
//  ContentView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            CalorieView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("칼로리")
                }
            WeightView()
                .tabItem {
                    Image(systemName: "scalemass")
                    Text("몸무게")
                }
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("내 정보")
                }
        }
    }
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:WeightEntry.self, CalorieData.self, Food.self, configurations: config)
        return ContentView()
            .environmentObject(MyModel())
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
