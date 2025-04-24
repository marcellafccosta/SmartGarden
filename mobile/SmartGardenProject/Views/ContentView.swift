//
//  ContentView.swift
//  SmartGarden
//
//  Created by Turma01-18 on 03/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var text = ""
    @State private var mostrarSheet = false
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.verdeEscuro
        UITabBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().backgroundColor = UIColor.verdeEscuro
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    var body: some View {
        ZStack {
            Color.verdeClaro.ignoresSafeArea()
            
            NavigationStack {
                TabView {
                    Group {
                        HomePage()
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                        
                        CreatePlant()
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Plant")
                        }
                        
                        
                        AlertsView()
                            .tabItem {
                                Image(systemName: "bell.fill")
                                Text("Alerts")
                            }
                    }
                }
                
                .accentColor(.verdeClaro)
                .navigationTitle("SmartGarden")
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
