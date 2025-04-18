//
//  DetailphotoViewController.swift
//  PhoriesApp
//
//  Created by Muhammet Yiğit on 17.04.2025.
//

import UIKit

class DetailphotoViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true

        
        if let photo = photo {
            if let imageData = photo.binaryPhoto {
                let image = UIImage(data: imageData)
                imageView.image = image
                locationLabel.text = photo.adress
            }
        }
    }
    
}
