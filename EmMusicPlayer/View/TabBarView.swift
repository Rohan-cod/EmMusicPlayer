//
//  TabBarView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 18/09/20.
//
import SwiftUI
import StoreKit
import MediaPlayer

struct TabBarView: View {
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    @available(iOS 14.0, *)
    var body: some View {
        
        TabView {
            ContentView(musicPlayer: self.$musicPlayer)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            SearchView(musicPlayer: self.$musicPlayer)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            EmotionView(musicPlayer: self.$musicPlayer)
                .tabItem {
                    Image(systemName: "person")
                    Text("Detect")
                }
            
            DashboardView()
                .tabItem {
                    Image(systemName: "text.and.command.macwindow")
                    Text("Dashboard")
                }
            
            LocationView()
                .tabItem {
                    Image(systemName: "location")
                    Text("Location")
                }
        }
        .accentColor(.pink)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
