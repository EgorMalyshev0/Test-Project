//
//  Route.swift
//  TestProject
//
//  Created by Egor Malyshev on 22.04.2021.
//

import Foundation

enum QueryRoute {
    
    case album(String), song(String)
    
    static let host = "itunes.apple.com"
    static let scheme = "https"
    
    var path: String {
        switch self {
        case .album:
            return "/search"
        case .song:
            return "/lookup"
        }
    }
    
    var queryParameters: [String : CustomStringConvertible] {
        switch self {
        case .album(let request):
            return ["term": request,
                    "entity": "album"]
        case .song(let request):
            return ["id": request,
                    "entity": "song"]
        }
    }
}
