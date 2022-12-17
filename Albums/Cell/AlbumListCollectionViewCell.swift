//
//  AlbumListCollectionViewCell.swift
//  Albums
//
//  Created by 박다연 on 2022/12/09.
//

import UIKit

class AlbumListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        albumImageView.clipsToBounds = true
        albumImageView.layer.cornerRadius = 5
    }
}
