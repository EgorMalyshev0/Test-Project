//
//  Loader.swift
//  TestProject
//
//  Created by Egor Malyshev on 04.12.2020.
//

import UIKit

class NetworkManager {
    
    var session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    func fetchAlbums(searchRequest: String, completion: @escaping (_ albums: [Album],_ error: String?) -> Void) {
        let transformedRequest = SearchRequestValidator().validate(searchRequest)
        guard let request = URLRequestBuilder().makeURLRequest(request: transformedRequest) else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion([], error.localizedDescription)
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let data = data{
                do {
                    let response = try decoder.decode(AlbumListResponse.self, from: data)
                    completion(response.results, nil)
                } catch {
                    completion([], error.localizedDescription)
                }
            }
        }.resume()
    }
    
    // Loading list of songs of the album
    class func loadSongs(collectionId: Int, completion: @escaping(SongListResponse)->()){
        let urlString = "https://itunes.apple.com/lookup?id=" + String(collectionId) + "&entity=song"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data,
               let parsedResult: SongListResponse = try? JSONDecoder().decode(SongListResponse.self, from: data){
                DispatchQueue.main.async {
                    completion(parsedResult)
                }
            }
        }
        task.resume()
    }
    
    // Loading image from cache or with url request
    class func loadImage(url: URL?, completion: @escaping(UIImage?, URL?)->()) {
        guard let temporaryUrl = url else { return }
        let urlString = temporaryUrl.absoluteString
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(cacheImage, temporaryUrl)
            return
        }
        let task = URLSession.shared.dataTask(with: temporaryUrl) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: urlString as AnyObject)
            DispatchQueue.main.async {
                completion(image, temporaryUrl)
            }
        }
        task.resume()
    }
    
}

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    
}

