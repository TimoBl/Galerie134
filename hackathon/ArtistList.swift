//
//  ArtistList.swift
//  hackathon
//
//  Created by Timo Blattner on 26.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI

struct ArtistList: View {
    var artists: [Artist] {return artistData}
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Artist Selection")
                .font(.headline)
                .padding(.leading, 10)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(self.artists) { artist in
                        ArtistPreview(artist: artist)
                    }
                }
            }
        }
    }
}

struct ArtistDetail: View {
    var artist: Artist
    
    var body: some View {
        VStack {
            ArtistImage(imageName: artist.imageName).frame(width: 200)
            Text(artist.artistName).font(.headline)
            Divider()
            ArtistPaintings(artistID: artist.id)
            
        }
    }
}

struct ArtistPaintings: View {
    let artistID: Int
    var paintings: [Painting]{paintingData.filter({$0.artistID == artistID})}
    var p: (left: [Painting], right: [Painting]){split(paintings: paintings)}
    
    var body: some View {
        HStack {
            VStack {
                ForEach(p.left){ painting in
                    PaintingPreview(painting: painting, showArtist: false)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                }
            }
            VStack {
                ForEach(p.right){ painting in
                    PaintingPreview(painting: painting, showArtist: true)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                        .padding(.leading, 5)
                }
            }
        }
    }
}

struct ArtistPreview: View {
    var artist: Artist
    
    var body: some View {
        NavigationLink(destination: ArtistDetail(artist: artist)) {
            VStack {
                ArtistImage(imageName: artist.imageName).frame(width: 100)
                Text(artist.artistName)
                    .font(.subheadline)
            }.padding(6)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ArtistLinePreview: View {
    var artist: Artist
    
    var body: some View {
        NavigationLink(destination: ArtistDetail(artist: artist)) {
            HStack {
                ArtistImage(imageName: artist.imageName).frame(width: 50)
                Text(artist.artistName)
                    .font(.subheadline)
            }.padding(6)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ArtistImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
        .resizable()
        .scaledToFit()
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .shadow(radius: 3)
    }
}

struct ArtistList_Previews: PreviewProvider {
    static var previews: some View {
        //ArtistList()
        ArtistDetail(artist: artistData[1])
    }
}
