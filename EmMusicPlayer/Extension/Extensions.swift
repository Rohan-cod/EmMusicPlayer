//
//  Extensions.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 03/12/20.
//


import Foundation


extension String: Identifiable {
    public var id: String {
        return self
    }
}
extension Int: Identifiable {
    public var id: Int {
        return self
    }
}
