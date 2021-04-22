//
//  AlbumCollectionViewCell.swift
//  TestProject
//
//  Created by Egor Malyshev on 04.12.2020.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBoutlets

    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    private var imageURL: URL? {
        didSet {
            albumImageView.image = nil
            NetworkManager.loadImage(url: imageURL) { (img, temporaryUrl) in
                if temporaryUrl == self.imageURL {
                    self.albumImageView.image = img
                }
            }
        }
    }
    
    //MARK: - Class methods
    
    func configurate(from album: Album) {
        collectionNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        imageURL = URL(string: album.artworkUrl100)
        albumImageView.layer.cornerRadius = 6
        albumImageView.layer.borderWidth = 0.3
        albumImageView.layer.borderColor = UIColor.gray.cgColor
    }
}

