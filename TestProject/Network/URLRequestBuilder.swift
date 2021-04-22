//
//  URLRequestBuilder.swift
//  TestProject
//
//  Created by Egor Malyshev on 22.04.2021.
//

import Foundation

class URLRequestBuilder {
    
    func makeURLRequest(request: String) -> URLRequest? {
        let route = QueryRoute.album(request)
        let components = makeComponents(route: route)
        guard let url = components.url else {
            return nil
        }
        print(url.absoluteString)
        return URLRequest(url: url)
    }
    
    private func makeComponents(route: QueryRoute) -> URLComponents {
        var components = URLComponents()
        components.scheme = QueryRoute.scheme
        components.host = QueryRoute.host
        components.path = route.path
        components.queryItems = makeQueryItems(parameters: route.queryParameters)
        return components
    }
    
    private func makeQueryItems(parameters: [String:CustomStringConvertible]) -> [URLQueryItem] {
        return parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value.description) }
    }
}
