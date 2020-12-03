//
//  Artist.swift
//  hackathon
//
//  Created by Timo Blattner on 05.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI

struct Artist: Hashable, Codable, Identifiable {
    var name: String
    var surname: String
    var artistName: String
    var id: Int
    var birthday: String
    var imageName: String
    
    static let `default` = Self(name: "Blattner", surname: "Timo", artistName: "TimoBl", id:2000, birthday: "10.12.2000", imageName: "TimoBlattner")
    
    var age: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let birthDate = formatter.date(from: birthday)
        let today = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate!, to: today)
        let ageYears = components.year
        return ageYears!
    }
}

struct Artist_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
