//
//  EmotionView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 18/09/20.
//



import SwiftUI
import StoreKit
import MediaPlayer
import SDWebImageSwiftUI
import CoreML
import Vision

struct EmotionView: View {
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    @State private var mood = String()
    @State private var recommendedSongs = [Song]()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var musicPlayer: MPMusicPlayerController
    private var text: String {
        if mood == "Happy" {
            return "Yay! You are Happy🤩\nSome songs for you to make your mood even better🤟"
        } else if mood == "Sad" {
            return "You are sad🙁\nThese songs will cheer you up🥳"
        } else {
            return mood
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    
                    VStack {
                        Image(uiImage: self.image)
                            .resizable()
                            .frame(width: 210, height: 300, alignment: .center)
                            .padding(.all, 5)
                        Text(text)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor((mood == "Happy" ? .green : .red))
                    }
                    .padding(.bottom, 20)
                    Spacer()
                    if !(self.recommendedSongs.isEmpty) {
                        Text("Recommended Songs")
                            .padding(.all, 10)
                            .font(.system(size: 30, weight: Font.Weight.heavy))
                    }
                    ForEach(self.recommendedSongs, id:\.id) { song in
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
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 15)
                            }
                        }
                        Divider()
                    }
                    Spacer()
                    
                }
                .navigationBarTitle(Text("Detect Emotion"))
                .navigationBarItems(leading: Button(action: {
                    self.sourceType = .photoLibrary
                    self.sourceType = .photoLibrary
                    self.sourceType = .photoLibrary
                    self.isShowPhotoLibrary = true
                }) {
                    Image(systemName: "photo")
                }, trailing: Button(action: {
                    self.sourceType = .camera
                    self.sourceType = .camera
                    self.sourceType = .camera
                    self.isShowPhotoLibrary = true
                }) {
                    Image(systemName: "camera")
                })
                .sheet(isPresented: $isShowPhotoLibrary, onDismiss: {
                    
                    guard let ciImage = CIImage(image: self.image) else {
                        print("Cannot generate CIImage.")
                        return
                    }
                    
                    detect(image: ciImage)
                    
                    SKCloudServiceController.requestAuthorization { (status) in
                        if status == .authorized {
                            print("Before")
                            if mood == "Happy" {
                                AppleMusicAPI().searchAppleMusic("Energetic Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Sad" {
                                AppleMusicAPI().searchAppleMusic("Happy Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else {
                                AppleMusicAPI().searchAppleMusic("Happy Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            }
                            
                            print("After")
                            print(self.recommendedSongs)
                        }
                    }
                    
                }) {
                    ImagePicker(selectedImage: self.$image, sourceType: self.sourceType)
                }
            }
            
            
        }
        
    }
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: EmotionClassifier2().model) else {
            print("Cannot create model.")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to process Image!")
            }
            
            if let result = results.first {
                self.mood = result.identifier
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("Error while performing VNCoreML Request - \(error.localizedDescription)")
        }
    }
}


