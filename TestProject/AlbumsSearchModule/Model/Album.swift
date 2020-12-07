//
//  Album.swift
//  TestProject
//
//  Created by Egor Malyshev on 04.12.2020.
//

import Foundation

struct Album {
    let artistName, collectionName, artworkUrl, primaryGenreName, releaseDateString, copyright: String
    let collectionId: Int
    var releaseDate: String {
        let dateFormatter = ISO8601DateFormatter()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        guard let date = dateFormatter.date(from: releaseDateString) else { return formatter.string(from: Date())}
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        guard let finalDate = calendar.date(from: components) else { return formatter.string(from: Date()) }
        return formatter.string(from: finalDate)
    }
    
    init?(data: NSDictionary) {
        guard let artistName = data["artistName"] as? String,
              let collectionName = data["collectionName"] as? String,
              let artworkUrl = data["artworkUrl100"] as? String,
              let primaryGenreName = data["primaryGenreName"] as? String,
              let releaseDateString = data["releaseDate"] as? String,
              let copyright = data["copyright"] as? String,
              let collectionId = data["collectionId"] as? Int
        else { return nil }
        
        self.artistName = artistName
        self.collectionName = collectionName
        self.artworkUrl = artworkUrl
        self.primaryGenreName = primaryGenreName
        self.releaseDateString = releaseDateString
        self.copyright = copyright
        self.collectionId = collectionId
    }
}
