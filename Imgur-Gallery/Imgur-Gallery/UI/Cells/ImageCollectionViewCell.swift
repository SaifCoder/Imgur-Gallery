//
//  ImageCollectionViewCell.swift
//  Imgur-Gallery
//
//  Created by Saifali Terdale on 14/06/23.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data:ImageData?) {
        let url = URL(string: data?.images?.first?.link ?? "")
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
    }

}
