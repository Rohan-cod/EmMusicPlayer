//
//  Place.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 03/12/20.
//

import Foundation

struct Place {
    var place_id: String
    var name: String
    var types: [String]
    
    init(place_id: String, name: String, types: [String]) {
        self.place_id = place_id
        self.name = name
        self.types = types
    }
}
