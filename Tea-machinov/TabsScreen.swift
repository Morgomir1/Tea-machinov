//
//  ContentView.swift
//  Tea-machinov
//
//  Created by user on 28.11.2025.
//

import SwiftUI

struct TabsScreen: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ShopView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Shop")
                }
                .tag(1)
            
            FavouritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }
                .tag(2)
            
            BagView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Bag")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Home Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationTitle("Home")
            .toolbar {
                // Кнопка возврата слева
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Действие при нажатии кнопки возврата
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                // Поле поиска справа
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                        
                        Button(action: {
                            // Действие при нажатии на лупу
                            print("Search for: \(searchText)")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

struct ShopView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Shop Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "cart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .navigationTitle("Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                        
                        Button(action: {
                            print("Search for: \(searchText)")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

struct FavouritesView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Favourites Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Favourites")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                        
                        Button(action: {
                            print("Search for: \(searchText)")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

struct BagView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Bag Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "bag.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .padding()
                }
            }
            .navigationTitle("Bag")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                        
                        Button(action: {
                            print("Search for: \(searchText)")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Profile Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.purple)
                        .padding()
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                        
                        Button(action: {
                            print("Search for: \(searchText)")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
