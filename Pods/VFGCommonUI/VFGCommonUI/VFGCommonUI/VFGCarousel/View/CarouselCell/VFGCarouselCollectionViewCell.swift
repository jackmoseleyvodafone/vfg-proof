//
//  VFGCarouselCollectionViewCell.swift
//  VFGCommonUI
//
//  Created by Łukasz Lewiński on 20/03/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit

class VFGCarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    var showSelectionIcon = true {
        didSet {
            selectionImageView.isHidden = !showSelectionIcon
        }
    }
    
    static let identifier = "VFGCarouselCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.layer.cornerRadius = max(frame.size.width, frame.size.height) / 2
        itemImageView.clipsToBounds = true
        
        selectionImageView.layer.cornerRadius = max(selectionImageView.frame.size.width, selectionImageView.frame.size.height) / 2
        selectionImageView.clipsToBounds = true
        selectionImageView.image = UIImage.fromBundleImage(#imageLiteral(resourceName: "tickOff"))
    }
    
    func selectCell(image: UIImage?) {
        itemImageView.image = image
        selectionImageView.image = UIImage.fromBundleImage(#imageLiteral(resourceName: "tick"))
    }
    
    func unSelectCell(image: UIImage?) {
        itemImageView.image = image
        selectionImageView.image = UIImage.fromBundleImage(#imageLiteral(resourceName: "tickOff"))
    }
}
