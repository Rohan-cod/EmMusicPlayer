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
    var colours: [String: Color] = ["Happy": Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), "Sad": Color(#colorLiteral(red: 0, green: 0.490196079, blue: 1, alpha: 1)), "Angry": Color(#colorLiteral(red: 1, green: 0.0112339483, blue: 0, alpha: 1)), "Fear": Color(#colorLiteral(red: 0.8131402526, green: 0, blue: 0.7656604921, alpha: 1)), "Surprise": Color(#colorLiteral(red: 0.9607843161, green: 0.5402659535, blue: 0.02331045362, alpha: 1)), "Neutral": Color(#colorLiteral(red: 0.6354643879, green: 0.400150011, blue: 0.1502078149, alpha: 1)), "Disgust": Color(#colorLiteral(red: 0.3352483009, green: 0.9607843161, blue: 0.1836980005, alpha: 1))]
    private var text: String {
        if mood == "Happy" {
            return "Yay! You are Happy🤩\nSome songs for you to make your mood even better🤟"
        } else if mood == "Sad" {
            return "You are Sad🙁\nThese songs will cheer you up🥳"
        } else if mood == "Angry" {
            return "You are Angry😡\nSome songs to help you cool down😇"
        } else if mood == "Disgust" {
            return "You are Disgust😫\nThese songs will help you improve your mood😃"
        } else if mood == "Fear" {
            return "You are Afraid😨\nDon't be afraid, listen to these songs and relax☺️"
        } else if mood == "Neutral" {
            return "Your mood is Neutral😐\nThese songs will cheer you up🥳"
        } else if mood == "Surprise" {
            return "You are Surprised😮\nSome songs According to your mood😀"
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
                            .foregroundColor(colours[mood])
                    }
                    .padding(.bottom, 20)
                    Spacer()
                    if !(self.recommendedSongs.isEmpty) {
                        Text("Recommended Songs")
                            .padding(.all, 10)
                            .font(.system(size: 30, weight: Font.Weight.heavy))
                            .foregroundColor(colours[mood])
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
                    
                    let currentCount = UserDefaults.standard.integer(forKey: mood)
                    UserDefaults.standard.set(currentCount+1, forKey: mood)
                    
                    
                    
                    SKCloudServiceController.requestAuthorization { (status) in
                        if status == .authorized {
                            print("Before")
                            if mood == "Happy" {
                                AppleMusicAPI().searchAppleMusic("Happy Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Sad" {
                                AppleMusicAPI().searchAppleMusic("Sad Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Angry" {
                                AppleMusicAPI().searchAppleMusic("Angry Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Disgust" {
                                AppleMusicAPI().searchAppleMusic("Disgust Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Fear" {
                                AppleMusicAPI().searchAppleMusic("Fear Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Neutral" {
                                AppleMusicAPI().searchAppleMusic("Neutral Songs") { (songs) in
                                    self.recommendedSongs = songs
                                }
                            } else if mood == "Surprise" {
                                AppleMusicAPI().searchAppleMusic("Surprise Songs") { (songs) in
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
        let configuration = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: EmotionClassification(configuration: configuration).model) else {
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


