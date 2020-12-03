//
//  GalleryList.swift
//  hackathon
//
//  Created by Timo Blattner on 04.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI
import MapKit

struct GalleryMapPreview: View {
    var gallery: Gallery
    
    var body: some View {
        ZStack{
            MapView(coordinate: gallery.locationCoordinate)
            Text(gallery.name)
                .bold()
                .offset(y: -40)
                .font(.title)
                .foregroundColor(Color.white)
        }.frame(width: 200, height: 200).clipShape(RoundedRectangle(cornerRadius: 30)).padding(10)
    }
}

struct GalleryDetail: View {
    var gallery: Gallery
    
    var body: some View {
        ScrollView {
            MapView(coordinate: gallery.locationCoordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 200)
             
            VStack {
                VStack(alignment: .leading) {
                    Text(gallery.name)
                        .font(.title)
                    HStack {
                        Text(gallery.location)
                            .font(.subheadline)
                        Spacer()
                        Text(gallery.country)
                            .font(.subheadline)
                    }
                }.padding()
                GalleryPaintings(galleryID: gallery.id)
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct PaintingList: View {
    let (p1, p2) = split(paintings: paintingData)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Painting Selection")
                .font(.headline)
                .padding(.leading, 10)
            HStack {
                VStack {
                    ForEach(p1){ painting in
                        PaintingPreview(painting: painting, showArtist: true)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                    }
                }
                VStack {
                    ForEach(p2){ painting in
                        PaintingPreview(painting: painting, showArtist: true)
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            .padding(.leading, 5)
                    }
                }
            }
        }
    }
}


struct GalleryPaintings: View {
    let galleryID: Int
    var paintings: [Painting]{paintingData.filter({$0.galleryID == galleryID})}
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


struct GalleriesNearYou: View {
    @ObservedObject var locationManager = LocationManager()
    
    var galleries: [Gallery] {
        if let loc = locationManager.lastLocation?.coordinate {
            return galleryData.filter({getDistance(loc1: loc, loc2: $0.locationCoordinate) <= 50})
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if galleries.count > 0 {
                HStack {
                    Text("Galleries near you")
                        .font(.headline)
                        .padding(.leading, 10)
                    Spacer()
                    Text("50km")
                        .font(.subheadline)
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.galleries) { gallery in
                            GalleryMiniPreview(gallery: gallery)
                        }
                    }
                }
                .frame(height: 200)
                .padding(.leading, 10)
            } else {
                Text("location status: \(locationManager.statusString)")
            }
        }
    }
}

struct GalleryList: View {
    var galleries: [Gallery]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Galleries in Switzerland")
                .font(.headline)
            ForEach(galleries){ gallery in
                NavigationLink(destination: GalleryDetail(gallery: gallery)){
                    GalleryMapPreview(gallery: gallery)
                    Spacer()
               }
            }
        }.padding(.leading, 10)
    }
}

struct GalleryMiniPreview: View {
    var gallery: Gallery
    
    var body: some View {
        NavigationLink(destination: GalleryDetail(gallery: gallery)){
             VStack {
                 Image(gallery.imageName)
                     .resizable()
                     .aspectRatio(1.0, contentMode: .fit)
                     .clipped()
                 Text(gallery.name)
                     .font(.subheadline)
             }
        }.buttonStyle(PlainButtonStyle())
    }
}

func getDistance(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Int {
    let R = 6371.0
    let delta_lat = deg2rad(deg: (loc2.latitude - loc1.latitude))
    let delta_lon = deg2rad(deg: (loc2.longitude - loc1.longitude))
    let a = sin(delta_lat / 2) * sin(delta_lat / 2) + cos(deg2rad(deg: loc1.latitude) * cos(deg2rad(deg: loc2.latitude))) * sin(delta_lon/2) * sin(delta_lon / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    let d = R * c
    return Int(d)
}

func deg2rad(deg: Double) -> Double {
    return deg * (Double.pi / 180)
}

func split(paintings: [Painting]) -> (left: [Painting], right: [Painting]) {
    let c = paintings.count
    let half = Int(c / 2)
    let right = paintings[0 ..< half]
    let left = paintings[half ..< c]
    return (Array(left), Array(right))
}

#if DEBUG
struct GalleryList_Previews: PreviewProvider {
    static var previews: some View {
        GalleryList(galleries: galleryData)
    }
}
#endif
