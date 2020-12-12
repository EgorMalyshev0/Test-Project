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
    
    //MARK: - Class methods

    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
    }
    
    func configurate(from album: Album) {
        collectionNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        albumImageView.loadImage(urlString: album.artworkUrl)
        albumImageView.layer.cornerRadius = 6
        albumImageView.layer.borderWidth = 0.3
        albumImageView.layer.borderColor = UIColor.gray.cgColor
    }
}

