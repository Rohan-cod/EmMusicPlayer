//
//  AppleMusicAPI.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 20/09/20.
//


import StoreKit

class AppleMusicAPI {
    let developerToken = ""
    let controller = SKCloudServiceController()
    
    func searchAppleMusic(_ searchTerm: String!, completion: @escaping ([Song]) -> ()) {
        var songs = [Song]()
        var toke = String()
        
        
        self.controller.requestUserToken(forDeveloperToken: developerToken) { (usertoken, error: Error?) in
            
            guard let token = usertoken else {
                print("Error getting user token.")
                return
            }
            
            toke = token
            
            let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/us/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25")!
            var musicRequest = URLRequest(url: musicURL)
            musicRequest.httpMethod = "GET"
            musicRequest.addValue("Bearer \(self.developerToken)", forHTTPHeaderField: "Authorization")
            musicRequest.addValue(token, forHTTPHeaderField: "Music-User-Token")
            
            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                guard error == nil else { return }
                guard let data = data else {
                    print("Data not found")
                    return
                }
                if let json = try? JSON(data: data) {
                    guard let results = (json["results"]["songs"]["data"]).array else {
                        print("not able to fetch results")
                        return
                    }
                    let result = results
                    for song in result {
                        let attributes = song["attributes"]
                        let currentSong = Song(id: attributes["playParams"]["id"].string!, name: attributes["name"].string!, artistName: attributes["artistName"].string!, artworkURL: attributes["artwork"]["url"].string!)
                        songs.append(currentSong)
                    }
                    completion(songs)
                } else {
                    completion(songs)
                }
            }.resume()
        }
    }
}
