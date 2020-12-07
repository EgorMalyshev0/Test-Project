//
//  Song.swift
//  TestProject
//
//  Created by Egor Malyshev on 05.12.2020.
//

import Foundation

struct Song {
    let trackName: String
    let trackNumber: Int
    var isExplicit: Bool = false
    
    init?(data: NSDictionary) {
        guard let trackName = data["trackName"] as? String,
              let trackNumber = data["trackNumber"] as? Int,
              let trackExplicitness = data["trackExplicitness"] as? String
        else { return nil }
        self.trackName = trackName
        self.trackNumber = trackNumber
        if trackExplicitness == "explicit" {
            self.isExplicit = true
        }
    }
}
