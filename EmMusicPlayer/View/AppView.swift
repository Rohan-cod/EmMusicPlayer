//
//  AppView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 18/09/20.
//

import SwiftUI
import Firebase
import StoreKit

struct AppView: View {
    var body: some View {
        
        Home()
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

struct Home : View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status {
                    
                    TabBarView()
                }
                else{
                    
                    ZStack{
                        Login()
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var hasAppleMusicSubscription = false
    
    var body: some View{
        
        ZStack {
            
            ZStack(alignment: .topTrailing) {
                
                GeometryReader {_ in
                    
                    VStack {
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                            .padding(.top, 35)
                        
                        Image("Auth")
                            .frame(width: 350, height: 350)
                            .padding(.all, 20)
                        
                        
                        
                        
                        if self.hasAppleMusicSubscription {
                            SignInWithAppleToFirebase({ response in
                                if response == .success {
                                    UserDefaults.standard.set(true, forKey: "status")
                                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                } else if response == .error {
                                    self.error = "Failed to Login!"
                                    self.alert.toggle()
                                }
                            })
                            .frame(width: 350, height: 50)
                        }
                        
                        if !self.hasAppleMusicSubscription {
                            Text("An Active Apple Music Subscription is required!")
                                .frame(width: 350, height: 50)
                        }
                        
                        
                        
                        
                        
                    }
                    .padding(.trailing, 35)
                    .padding(.leading, -10)
                }
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .onAppear() {
            let controller = SKCloudServiceController()
            controller.requestCapabilities { (capabilities: SKCloudServiceCapability, error: Error?) in
                guard error == nil else { return }
                
                if (capabilities.contains(.musicCatalogSubscriptionEligible) && !capabilities.contains(.musicCatalogPlayback)) {
                    self.hasAppleMusicSubscription = false
                } else {
                    
                    self.hasAppleMusicSubscription = true
                    
                }
            }
        }
    }
}


struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
