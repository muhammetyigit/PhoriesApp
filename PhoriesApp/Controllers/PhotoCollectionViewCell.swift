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
        deleteButton.isHidden = true // hücre oluşturulurken gizle
    }
    
    
    override func prepareForReuse() {
            super.prepareForReuse()
            deleteButton.isHidden = true // yeniden kullanıldığında da gizli başlasın
        }
    
    func setDeleteButtonVisibility(_ isVisible: Bool, animated: Bool = true) {
        if animated {
            // Butonu görünür yapıyoruz, alpha animasyonu başladığında görünür olmalı
            deleteButton.isHidden = false
            
            // Animasyonu yavaşlatmak için duration değerini arttırıyoruz
            UIView.animate(withDuration: 1.0) {  // Bu değeri büyüterek animasyonu daha da yavaşlatabilirsiniz
                self.deleteButton.alpha = isVisible ? 1 : 0
            } completion: { _ in
                // Animasyon bitiminde, sadece alpha değeri sıfırsa gizle
                if self.deleteButton.alpha == 0 {
                    self.deleteButton.isHidden = true
                }
            }
        } else {
            // Animasyon yoksa hemen görünürlüğü değiştirelim
            deleteButton.isHidden = !isVisible
            deleteButton.alpha = isVisible ? 1 : 0
        }
    }
}
