import SwiftUI

struct ContentView: View {
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
        .accentColor(.blue) // Цвет выбранной вкладки
    }
}

// MARK: - Views для каждой вкладки

struct HomeView: View {
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
        }
    }
}

struct ShopView: View {
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
        }
    }
}

struct FavouritesView: View {
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
        }
    }
}

struct BagView: View {
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
        }
    }
}

struct ProfileView: View {
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
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}