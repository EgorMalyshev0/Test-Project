//
//  AlbumsSearchViewController.swift
//  TestProject
//
//  Created by Egor Malyshev on 03.12.2020.
//

import UIKit
import ReactiveKit

class AlbumsSearchViewController: UIViewController {
    
    // MARK: - Elements
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    @IBOutlet weak var centerLabel: UILabel!

    // MARK: - Property
    
    var albums: [Album] = [] {
        didSet {
            self.albumsCollectionView.reloadData()
        }
    }
    let debouncer = Debouncer(timeInterval: 0.5)
    let searchController = UISearchController(searchResultsController: nil)
     
    // MARK: - AlbumsSearchViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
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
        
    func retrieveAlbums(forSearchRequest request: String){
        if request.isEmpty {
            albums.removeAll()
            centerLabel.text = "Enter your search request"
            centerLabel.isHidden = false
        } else {
            centerLabel.isHidden = true
            debouncer.renewInterval()
            debouncer.handler = {
                NetworkManager().fetchAlbums(searchRequest: request) { (albums, errorDescription) in
                    DispatchQueue.main.async {
                        if let error = errorDescription {
                            print(error)
                        }
                        guard !albums.isEmpty else {
                            self.albums.removeAll()
                            self.centerLabel.text = "Nothing found"
                            self.centerLabel.isHidden = false
                            return
                        }
                        self.albums = albums.sorted { $0.collectionName < $1.collectionName }
                    }
                }
            }
        }
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout

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

    //MARK: - UISearchBarDelegate

extension AlbumsSearchViewController: UISearchBarDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(false)
    }
}

extension AlbumsSearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let bar = searchController.searchBar
        retrieveAlbums(forSearchRequest: bar.text!)
    }
}

