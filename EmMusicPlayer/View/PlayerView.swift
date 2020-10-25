//
//  PlayerView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 20/09/20.
//

import SwiftUI
import MediaPlayer
import SDWebImageSwiftUI

struct PlayerView: View {
    @Binding var musicPlayer: MPMusicPlayerController
    @State private var isPlaying = false
    var currentSong: Song
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: HorizontalAlignment.center , spacing: 24) {
                WebImage(url: URL(string: self.currentSong.artworkURL.replacingOccurrences(of: "{w}", with: "\(Int(geometry.size.width - 24) * 2)").replacingOccurrences(of: "{h}", with: "\(Int(geometry.size.width - 24) * 2)")))
                    .resizable()
                    .frame(width: abs(geometry.size.width - 24), height: abs(geometry.size.width - 24))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                VStack(spacing: 8) {
                    Text(self.currentSong.name)
                        .font(Font.system(.title).bold())
                        .multilineTextAlignment(.center)
                    Text(self.currentSong.artistName)
                        .font(.system(.headline))
                }
                
                
                HStack(spacing: 40) {
                    Spacer()
                    Button(action: {
                        if self.musicPlayer.currentPlaybackRate <= 0.50 {
                            self.musicPlayer.pause()
                            self.musicPlayer.currentPlaybackRate = 1.0
                            self.isPlaying = false
                        } else {
                            self.musicPlayer.currentPlaybackRate -= 0.05
                        }
                        
                    }) {
                        ZStack {
                            Image(systemName: "backward.fill")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .font(.system(.title))
                        }
                    }
                    
                    
                    
                    Button(action: {
                        if self.musicPlayer.playbackState == .paused || self.musicPlayer.playbackState == .stopped {
                            self.musicPlayer.setQueue(with: [currentSong.id])
                            
                            self.musicPlayer.play()
                            self.musicPlayer.currentPlaybackRate = 1.0
                            self.isPlaying = true
                        } else {
                            self.musicPlayer.currentPlaybackRate = 1.0
                            self.musicPlayer.pause()
                            
                            self.isPlaying = false
                        }
                    }) {
                        ZStack {
                            Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .font(.system(.title))
                        }
                    }
                    
                    
                    
                    
                    Button(action: {
                        
                        
                        if self.musicPlayer.currentPlaybackRate >= 1.50 {
                            
                            self.musicPlayer.currentPlaybackRate = 1.95
                            
                            
                        } else {
                            self.musicPlayer.currentPlaybackRate += 0.05
                        }
                    }) {
                        ZStack {
                            Image(systemName: "forward.fill")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .font(.system(.title))
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 60)
                
                
            }
        }
        .navigationBarTitle("Now Playing")
        .onAppear() {
            
            self.musicPlayer.setQueue(with: [currentSong.id])
            self.musicPlayer.play()
            self.musicPlayer.currentPlaybackRate = 1.0
            self.isPlaying = true
        }
        .onDisappear() {
            
            self.musicPlayer.currentPlaybackRate = 1.0
            self.musicPlayer.pause()
            
            self.isPlaying = false
        }
    }
}
