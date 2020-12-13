//
//  Song.swift
//  TestProject
//
//  Created by Egor Malyshev on 05.12.2020.
//

import Foundation

struct Song: Codable {
    let wrapperType: WrapperType
    let trackName: String?
    let trackNumber: Int?
    let trackExplicitness: Explicitness?
}

struct SongListResponse: Decodable {
    let resultCount: Int
    let results: [Song]
}

enum Explicitness: String, Codable {
    case explicit = "explicit"
    case notExplicit = "notExplicit"
}

enum WrapperType: String, Codable {
    case collection = "collection"
    case track = "track"
}
