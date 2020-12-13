//
//  AlbumsSearchViewController.swift
//  TestProject
//
//  Created by Egor Malyshev on 03.12.2020.
//

import UIKit
import Bond
import ReactiveKit

class AlbumsSearchViewController: UIViewController {
    
    // MARK: - IBoutlets
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK: - Class properties
    
    var albums: [Album] = []
     
    //MARK: - UIViewController events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
//        setupSearchBarListener()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? AlbumCollectionViewCell,
           let index = albumsCollectionView.indexPath(for: cell)?.row,
           let vc = segue.destination as? AlbumDetailsViewController,
           segue.identifier == "showAlbumDetails" {
            vc.album = albums[index]
            vc.albumImage = cell.albumImageView.image
        }
    }
    
    //MARK: - Class methods

//    fileprivate func setupSearchBarListener(){
//        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
//        publisher.sink { (str) in
//            print("123")
//        }
//        publisher.map {
//            (($0.object as! UISearchTextField).text)
//        }
//        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .sink { (text) in
//                Loader.loadAlbums(searchRequest: text ?? "") { (response) in
//                    self.albums = response.results.sorted { $0.collectionName < $1.collectionName }
//                    self.albumsCollectionView.reloadData()
//                }
//        }
    }
    
    
    
//    func configureRx()  {
//        albums.bind(to: albumsCollectionView) { (dataSource, indexPath, collectionView) -> UICollectionViewCell in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumView", for: indexPath) as! AlbumCollectionViewCell
//            cell.configurate(from: dataSource[indexPath.row])
//            return cell
//        }
        
//        searchBar.reactive.text.debounce(for: 0.15)
//            .ignoreNils()
//            .map {$0.isEmpty ? false : true}
//            .bind(to: centerLabel.reactive.isHidden)
//        combination.map{$0 ? "Nothing found" : "Enter your search request"}
//            .bind(to: centerLabel.reactive.text)
//
//        searchBar.reactive.text.debounce(for: 0.15)
//            .ignoreNils()
//            .map {$0.isEmpty ? false : true}
//            .bind(to: centerLabel.reactive.isHidden)
//
//        albums.map {$0.collection.isEmpty ? "Nothing found" : "Enter your search request"}
//            .bind(to: centerLabel.reactive.text)
//
//        searchBar.reactive.text.debounce(for: 0.1)
//            .ignoreNils()
//            .observeNext { (text) in
//                self.albums.removeAll()
//            }
//
//        searchBar.reactive.text.ignoreNils()
//            .filter {$0.count > 0}
//            .debounce(for: 0.5)
//            .observeNext { (text) in
//                Loader.loadAlbums(searchRequest: text) { (response) in
//                    let sortedArray = response.results.sorted { $0.collectionName < $1.collectionName }
//                    for album in sortedArray {
//                        self.albums.append(album)
//                    }
//                }
//            }
//    }
//}

    //MARK: - UICollectionViewDelegateFlowLayout methods

extension AlbumsSearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumView", for: indexPath) as! AlbumCollectionViewCell
        cell.configurate(from: albums[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = self.view.frame.width
        let itemsPerRow: CGFloat = 2
        let paddingSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (itemsPerRow - 1)
        let availableWidth = width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        // This value is needed to count cell's height correctly. (In fact it's the fixed height of stackView in cell)
        let fixedValue: CGFloat = 40

        return CGSize(width: widthPerItem, height: widthPerItem + fixedValue)
    }
}

    //MARK: - UISearchBarDelegate methods

extension AlbumsSearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Loader.loadAlbums(searchRequest: searchText) { (response) in
            let sortedArray = response.results.sorted { $0.collectionName < $1.collectionName }
            self.albums = sortedArray
            self.albumsCollectionView.reloadData()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
