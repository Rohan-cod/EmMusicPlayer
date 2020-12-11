//
//  DashboardView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 03/12/20.
//


import SwiftUI

@available(iOS 14.0, *)
struct DashboardView: View {
    
    @AppStorage("Happy") var happyCount: Int = 0
    @AppStorage("Sad") var sadCount: Int = 0
    @AppStorage("Disgust") var disgustCount: Int = 0
    @AppStorage("Neutral") var neutralCount: Int = 0
    @AppStorage("Surprise") var surpriseCount: Int = 0
    @AppStorage("Fear") var fearCount: Int = 0
    @AppStorage("Angry") var angryCount: Int = 0
    var total: Int {
        (happyCount + sadCount + disgustCount + neutralCount + surpriseCount + fearCount + angryCount)
    }
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var emotions: [String] = ["Happy", "Sad", "Angry", "Fear", "Surprise", "Neutral", "Disgust"]
    var emotionCounts: [Int] {
        [happyCount, sadCount, angryCount, fearCount, surpriseCount, neutralCount, disgustCount]
    }
    var indexes: [Int] = [0, 1, 2, 3, 4, 5, 6]
    var colours: [Color] = [Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.490196079, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.0112339483, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.8131402526, green: 0, blue: 0.7656604921, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.5402659535, blue: 0.02331045362, alpha: 1)), Color(#colorLiteral(red: 0.6354643879, green: 0.400150011, blue: 0.1502078149, alpha: 1)), Color(#colorLiteral(red: 0.3352483009, green: 0.9607843161, blue: 0.1836980005, alpha: 1))]
    
    var emojis: [String] = ["😀", "☹️", "😡", "😨", "😮", "😐", "😫"]
    
    var maxCount: Int {
        emotionCounts.max() ?? 0
    }
    
    var colorMax: Color {
        if maxCount == 0 {
            return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        } else {
            if let index = emotionCounts.firstIndex(of: maxCount) {
                return colours[index]
            } else {
                return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            }
        }
    }
    
    var emojiMax: String {
        if maxCount == 0 {
            return ""
        } else {
            if let index = emotionCounts.firstIndex(of: maxCount) {
                return emojis[index]
            } else {
                return ""
            }
        }
    }
    
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack {
                
                HStack{
                    
                    Text("Dashboard\(emojiMax)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorMax)
                    Spacer()
                    Text("\(total)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(colorMax)
                }
                .padding()
                
                LazyVGrid(columns: columns, spacing: 30){
                    
                    ForEach(indexes){index in
                        
                        VStack(spacing: 32){
                            
                            HStack{
                                Text(emotions[index])
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                            }
                            
                            ZStack{
                                
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(colours[index].opacity(0.05), lineWidth: 10)
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Circle()
                                    .trim(from: 0, to: (CGFloat(emotionCounts[index]) / CGFloat(total)))
                                    .stroke(colours[index], style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Text(getPercent(count: CGFloat(emotionCounts[index]), total: CGFloat(total)) + " %")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(colours[index])
                                    .rotationEffect(.init(degrees: 90))
                            }
                            .rotationEffect(.init(degrees: -90))
                            
                            Text(String(emotionCounts[index]))
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                    }
                }
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
    
    func getDec(val: CGFloat)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        return format.string(from: NSNumber.init(value: Float(val)))!
    }
    
    func getPercent(count : CGFloat, total : CGFloat)->String{
        if count == 0 {
            return String("0")
        }
        
        let per = (count / total) * 100
        
        return String(format: "%.1f", per)
    }
    
}

struct RoundedShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}

