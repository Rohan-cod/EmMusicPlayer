//
//  SearchView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 18/09/20.
//

import SwiftUI
import StoreKit
import MediaPlayer
import SDWebImageSwiftUI


struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults = [Song]()
    @Binding var musicPlayer: MPMusicPlayerController
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    TextField("Search", text: $searchText, onCommit: {
                        UIApplication.shared.resignFirstResponder()
                        if self.searchText.isEmpty {
                            self.searchResults = []
                        } else {
                            SKCloudServiceController.requestAuthorization { (status) in
                                if status == .authorized {
                                    print("Before")
                                    AppleMusicAPI().searchAppleMusic(self.searchText) { (songs) in
                                        self.searchResults = songs
                                    }
                                    print("After")
                                    print(self.searchResults)
                                }
                            }
                        }
                    })
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.searchText = ""
                                    
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                    
                    if isEditing {
                        Button(action: {
                            self.isEditing = false
                            self.searchText = ""
                            
                            self.searchResults = []
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Cancel")
                        }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        .accentColor(.pink)
                    }
                }
                
                List {
                    ForEach(searchResults, id:\.id) { song in
                        NavigationLink(destination: PlayerView(musicPlayer: $musicPlayer, currentSong: song)) {
                            HStack {
                                WebImage(url: URL(string: song.artworkURL.replacingOccurrences(of: "{w}", with: "80").replacingOccurrences(of: "{h}", with: "80")))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(5)
                                    .shadow(radius: 2)
                                
                                VStack(alignment: .leading) {
                                    Text(song.name)
                                        .font(.headline)
                                    Text(song.artistName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .accentColor(.pink)
            }
            .navigationBarTitle("Songs")
        }
    }
}

