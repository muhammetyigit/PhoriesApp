//
//  PhotoCollectionViewCell.swift
//  PhoriesApp
//
//  Created by Muhammet Yiğit on 17.04.2025.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.isHidden = true
    }
    
    func setDeleteButtonVisibility(_ isVisible: Bool, animated: Bool = true) {
        if animated {
            deleteButton.isHidden = false
            
            UIView.animate(withDuration: 1.0) {
                self.deleteButton.alpha = isVisible ? 1 : 0
            } completion: { _ in
                if self.deleteButton.alpha == 0 {
                    self.deleteButton.isHidden = true
                }
            }
        } else {
            deleteButton.isHidden = !isVisible
            deleteButton.alpha = isVisible ? 1 : 0
        }
    }
}
