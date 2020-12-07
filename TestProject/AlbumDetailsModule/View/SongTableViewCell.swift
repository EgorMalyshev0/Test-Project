//
//  SongTableViewCell.swift
//  TestProject
//
//  Created by Egor Malyshev on 05.12.2020.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    // MARK: - IBoutlets
    
    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var explicitnessView: UIView!
    
    //MARK: - Class methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(from song: Song) {
        trackNumberLabel.text = String(song.trackNumber)
        trackNameLabel.text = song.trackName
        if !song.isExplicit{
            explicitnessView.isHidden = true
        }
        explicitnessView.layer.cornerRadius = 2
    }

}
