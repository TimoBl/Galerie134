//
//  Home.swift
//  hackathon
//
//  Created by Timo Blattner on 10.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical){
                VStack {
                    Divider()
                    GalleriesNearYou()
                    Divider()
                    //GalleryList(galleries: galleryData)
                    PaintingList()
                    GalleryMap(galleries: galleryData).frame(height: 160)
                    //Divider()
                    ArtistList()
                }
                .navigationBarTitle(Text("Galerie134"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
        .previewDevice(PreviewDevice(rawValue: "iPhone XS"))
    }
}
