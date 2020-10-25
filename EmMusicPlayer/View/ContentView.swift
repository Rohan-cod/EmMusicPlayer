//
//  ContentView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 18/09/20.
//

import SwiftUI
import Firebase
import StoreKit
import MediaPlayer
import SDWebImageSwiftUI


struct ContentView: View {
    
    @State private var recommendedSongs = [Song]()
    @State private var trendingSongs = [Song]()
    @Binding var musicPlayer: MPMusicPlayerController
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: HorizontalAlignment.leading , spacing: 6) {
                    Text("Trending Songs")
                        .padding(.leading, 1)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        .font(.system(size: 20, weight: Font.Weight.bold))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(trendingSongs, id:\.id) { song in
                                NavigationLink(destination: PlayerView(musicPlayer: $musicPlayer, currentSong: song)) {
                                    VStack(alignment: HorizontalAlignment.leading , spacing: 3) {
                                        WebImage(url: URL(string: song.artworkURL.replacingOccurrences(of: "{w}", with: "170").replacingOccurrences(of: "{h}", with: "170")))
                                            .resizable()
                                            .frame(width: 170, height: 170)
                                            .cornerRadius(5)
                                            .shadow(radius: 2)
                                        Text(song.name)
                                            .font(.headline)
                                            .frame(width: 170, height: 20)
                                        
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .accentColor(.white)
                    
                    Divider()
                    
                    Text("Recommended Songs")
                        .padding(.leading, 1)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .font(.system(size: 20, weight: Font.Weight.bold))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(recommendedSongs, id:\.id) { song in
                                NavigationLink(destination: PlayerView(musicPlayer: $musicPlayer, currentSong: song)) {
                                    VStack(alignment: HorizontalAlignment.leading , spacing: 6) {
                                        WebImage(url: URL(string: song.artworkURL.replacingOccurrences(of: "{w}", with: "170").replacingOccurrences(of: "{h}", with: "170")))
                                            .resizable()
                                            .frame(width: 170, height: 170)
                                            .cornerRadius(5)
                                            .shadow(radius: 2)
                                        Text(song.name)
                                            .font(.headline)
                                            .frame(width: 170, height: 20)
                                        
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .accentColor(.white)
                }
                .padding(.leading, 20)
                
            }
            .navigationBarTitle(Text("Menu"))
            .navigationBarItems(trailing: Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }) {
                Text("Sign out")
            })
        }
        .onAppear() {
            AppleMusicAPI().searchAppleMusic("Recommended Songs") { (songs) in
                self.recommendedSongs = songs
            }
            AppleMusicAPI().searchAppleMusic("Trending Songs") { (songs) in
                self.trendingSongs = songs
            }
        }
    }
}


