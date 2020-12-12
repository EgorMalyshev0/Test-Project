//
//  Loader.swift
//  TestProject
//
//  Created by Egor Malyshev on 04.12.2020.
//

import UIKit

class Loader {
    
    // Loading albums info from ITunes API
    class func loadAlbums(searchRequest: String, completion: @escaping([Album])->()){
        let transformedSearchRequest = searchRequest.applyingTransform(.toLatin, reverse: false)
        let finalSearchRequest = (transformedSearchRequest != nil) ? transformedSearchRequest! : searchRequest
        let urlString = "https://itunes.apple.com/search?term=" + finalSearchRequest + "&entity=album"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
                var albums: [Album] = []
                if let resultsArray = jsonDict["results"] as? NSArray {
                    for resultData in resultsArray where resultData is NSDictionary {
                        if let album = Album(data: resultData as! NSDictionary){
                            albums.append(album)
                        }
                    }
                    DispatchQueue.main.async {
                        let sortedArray = albums.sorted { $0.collectionName < $1.collectionName }
                        completion(sortedArray)
                    }
                }
            }
        }
        task.resume()
    }
    
    // Loading list of songs of the album
    class func loadSongs(collectionId: Int, completion: @escaping([Song])->()){
        let collectionIdString = String(collectionId)
        let urlString = "https://itunes.apple.com/lookup?id=" + collectionIdString + "&entity=song"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
                var songs: [Song] = []
                if let resultsArray = jsonDict["results"] as? NSArray {
                    for resultData in resultsArray where resultData is NSDictionary {
                        if let song = Song(data: resultData as! NSDictionary){
                            songs.append(song)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(songs)
                    }
                }
            }
        }
        task.resume()
    }
}

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    // Loading image from cache or with url request
    func loadImage(urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: urlString as AnyObject)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}

