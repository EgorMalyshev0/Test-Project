//
//  Album.swift
//  TestProject
//
//  Created by Egor Malyshev on 04.12.2020.
//

import Foundation

struct Album: Codable {
    let artistName, collectionName, artworkUrl100, primaryGenreName, copyright: String
    let collectionId: Int
    let releaseDate: Date
}

struct AlbumListResponse: Decodable {
    let resultCount: Int
    let results: [Album]
}

extension Date {
    func yearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
}
