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
    
    @IBOutlet weak var albumsCollectionView: AlbumsCollectionView!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK: - Class properties
    
    var albums: MutableObservableArray<Album> = MutableObservableArray([])
     
    //MARK: - UIViewController events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        configureRx()
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

    func configureRx()  {
        albums.bind(to: albumsCollectionView) { (dataSource, indexPath, collectionView) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumView", for: indexPath) as! AlbumCollectionViewCell
            cell.configurate(from: dataSource[indexPath.row])
            return cell
        }
        
        searchBar.reactive.text.debounce(for: 0.15)
            .ignoreNils()
            .map {$0.isEmpty ? false : true}
            .bind(to: centerLabel.reactive.isHidden)
        
        searchBar.reactive.text.debounce(for: 0.1)
            .ignoreNils()
            .observeNext { (text) in
                self.albums.removeAll()
            }
        
        searchBar.reactive.text.debounce(for: 0.5)
            .ignoreNils()
            .observeNext { (text) in
                Loader.shared.loadAlbums(searchRequest: text) { (albums) in
                    for album in albums {
                        self.albums.append(album)
                    }
                }
            }
    }

}

    //MARK: - UICollectionViewDelegateFlowLayout methods

extension AlbumsSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return albumsCollectionView.countSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return albumsCollectionView.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return albumsCollectionView.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return albumsCollectionView.minimumItemSpacing
    }
}

    //MARK: - UISearchBarDelegate methods

extension AlbumsSearchViewController: UISearchBarDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
