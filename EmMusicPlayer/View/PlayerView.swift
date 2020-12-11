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
    @State var finish = false
    @State var width : CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                
                
                
                VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                    VStack(alignment: HorizontalAlignment.leading, spacing: 8) {
                        WebImage(url: URL(string: self.currentSong.artworkURL.replacingOccurrences(of: "{w}", with: "\(Int(geometry.size.width - 24) * 2)").replacingOccurrences(of: "{h}", with: "\(Int(geometry.size.width - 24) * 2)")))
                            .resizable()
                            .frame(alignment: .center)
                            .frame(width: abs(geometry.size.width - 24), height: abs(geometry.size.width - 24))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        VStack(alignment: HorizontalAlignment.leading, spacing: 8) {
                            Text(self.currentSong.name)
                                .font(Font.system(.title).bold())
                                .multilineTextAlignment(.center)
                            VStack(alignment: HorizontalAlignment.center, spacing: 8) {
                                Text(self.currentSong.artistName)
                                    .font(.system(.headline))
                            }
                                
                        }
                        
                        Capsule().fill(Color.red).frame(width: self.width, height: 8)
                            .gesture(DragGesture()
                                        .onChanged({ (value) in
                                            
                                            let x = value.location.x
                                            
                                            self.width = x
                                            
                                        }).onEnded({ (value) in
                                            
                                            let x = value.location.x
                                            
                                            let screen = UIScreen.main.bounds.width - 30
                                            
                                            let percent = x / screen
                                            
                                            guard let duration = self.musicPlayer.nowPlayingItem?.playbackDuration.magnitude else {
                                                return
                                            }
                                            
                                            self.musicPlayer.currentPlaybackTime = Double(percent) * duration
                                        }))
                        
                    }
                    HStack(spacing: 5) {
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
                        
                        Spacer()
                        
                        Button(action: {
                            
                            self.musicPlayer.currentPlaybackTime -= 15
                            
                        }) {
                            
                            Image(systemName: "gobackward.15").font(.title)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .font(.system(.title))
                            
                        }
                        
                        Spacer()
                        
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
                        
                        Spacer()
                        
                        Button(action: {
                            
                            let increase = self.musicPlayer.currentPlaybackTime + 15
                            
                            guard let duration = self.musicPlayer.nowPlayingItem?.playbackDuration.magnitude else {
                                return
                            }
                            
                            if increase < duration {
                                
                                self.musicPlayer.currentPlaybackTime = increase
                                
                            }
                            
                        }) {
                            
                            Image(systemName: "goforward.15")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .font(.system(.title))
                            
                        }
                        
                        Spacer()
                        
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
                        
                    }
                    .padding(.bottom, 60)
                    .padding(.trailing, 26)
                    .padding(.leading, -10)
                }
                .padding(.leading, 15)
                
            }
        }
        .navigationBarTitle("Now Playing")
        .onAppear() {
            
            self.musicPlayer.setQueue(with: [currentSong.id])
            self.musicPlayer.play()
            self.musicPlayer.currentPlaybackRate = 1.0
            self.isPlaying = true
            
            guard let duration = self.musicPlayer.nowPlayingItem?.playbackDuration.magnitude else {
                return
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                
                if self.isPlaying {
                    
                    let screen = UIScreen.main.bounds.width - 30
                    
                    let value = self.musicPlayer.currentPlaybackTime / duration
                    
                    if self.musicPlayer.currentPlaybackTime == duration {
                        self.musicPlayer.currentPlaybackRate = 1.0
                        self.finish = true
                        self.musicPlayer.pause()
                        self.isPlaying = false
                    }
                    
                    self.width = screen * CGFloat(value)
                }
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                
                self.finish = true
                self.musicPlayer.pause()
                self.isPlaying = false
            }
        }
        .onDisappear() {
            
            self.musicPlayer.currentPlaybackRate = 1.0
            self.musicPlayer.pause()
            
            self.isPlaying = false
        }
    }
}

