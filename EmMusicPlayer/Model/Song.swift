//
//  Song.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 20/09/20.
//

import Foundation

struct Song {
    var id: String
    var name: String
    var artistName: String
    var artworkURL: String
    
    init(id: String, name: String, artistName: String, artworkURL: String) {
        self.id = id
        self.name = name
        self.artworkURL = artworkURL
        self.artistName = artistName
    }
}
