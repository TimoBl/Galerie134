//
//  PaintingDetail.swift
//  hackathon
//
//  Created by Timo Blattner on 04.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI

public var global = 0

struct PaintingDetail: View {
    var painting: Painting
    var showArtist: Bool
    var artist: Artist {
        artistData.filter({$0.id == painting.artistID})[0]
    }
    @State var isPresented: Bool = false

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button(action: { self.isPresented.toggle() }) {
                    Image(systemName: "info.circle").padding(10)
                }.sheet(isPresented: $isPresented) {
                    Text(self.painting.name).bold()
                    Divider()
                    Text(self.painting.description)
                }
            }
            Image(painting.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            if showArtist {
                ArtistLinePreview(artist: artist)
            }
            Divider()
            NavigationLink(destination: ArView(painting: painting)) {
                 Text("View in AR")
            }
            Spacer()
        }
        .navigationBarTitle(painting.name)
    }
}

struct PaintingPreview: View {
    var painting: Painting
    var showArtist: Bool
    
    var body: some View {
        NavigationLink(destination: PaintingDetail(painting: painting, showArtist: showArtist)){
            VStack {
                Image(painting.imageName)
                   .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(painting.name)
                    .font(.subheadline)
            }
       }.buttonStyle(PlainButtonStyle())
    }
}

struct PaintingDetail_Previews: PreviewProvider {
    static var previews: some View {
        PaintingDetail(painting: paintingData[2], showArtist: true)
    }
}
