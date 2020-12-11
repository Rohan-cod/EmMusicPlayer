//
//  LocationView.swift
//  EmMusicPlayer
//
//  Created by pamarori mac on 03/12/20.
//

import SwiftUI

struct LocationView: View {
    
    @ObservedObject var lm = LocationManager()
    
    @State private var places = [Place]()
    var latitude: Double  {
        return(lm.location?.latitude ?? 0)
    }
    
    var longitude: Double {
        return(lm.location?.longitude ?? 0)
    }
    
    var placemark: String {
        return("\(lm.placemark?.description ?? "XXX")")
        
    }
    
    var status: String {
        return("\(String(describing: lm.status))")
    }
    
    var body: some View {
        Text("Currently not available!")
            .onAppear() {
            }
    }
    
    
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
