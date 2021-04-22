//
//  AlbumDetailsViewController.swift
//  TestProject
//
//  Created by Egor Malyshev on 05.12.2020.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
   
    // MARK: - IBoutlets
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var songsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Class properties
    
    var album: Album?
    var albumImage: UIImage?
    var songs: [Song] = []
    
    //MARK: - UIViewController events

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        songsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        guard let album = album else { return }
        NetworkManager.loadSongs(collectionId: album.collectionId) { (response) in
            self.songs = response.results.filter{$0.wrapperType == .track}
            self.activityIndicator.stopAnimating()
            self.copyrightLabel.isHidden = false
            self.songsTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        songsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // We use this to change the height of tableView's contentSize in buildtime
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                songsTableViewHeight.constant = newSize.height
            }
        }
    }
    
    func configurateViews(){
        if let image = albumImage{
            albumImageView.image = image
            albumImageView.layer.cornerRadius = 6
            albumImageView.layer.borderWidth = 0.3
            albumImageView.layer.borderColor = UIColor.gray.cgColor
        }
        if let album = album {
            collectionNameLabel.text = album.collectionName
            artistNameLabel.text = album.artistName
            genreLabel.text = album.primaryGenreName.uppercased()
            separatorView.layer.cornerRadius = separatorView.frame.width / 2
            releaseYearLabel.text = album.releaseDate.yearString()
            copyrightLabel.text = album.copyright
        }
    }
}

    //MARK: - UITableViewDelegate & UITableViewDataSource methods

extension AlbumDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "song") as! SongTableViewCell
        cell.configure(from: songs[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
