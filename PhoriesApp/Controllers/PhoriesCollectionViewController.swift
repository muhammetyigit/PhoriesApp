//
//  PhoriesCollectionViewController.swift
//  PhoriesApp
//
//  Created by Muhammet Yiğit on 16.04.2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhoriesCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
    
    // MARK: - HeadingUIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if let image = image.jpegData(compressionQuality: 0.8) {
                    
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        // İptal edilirse
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    // MARK: - Functions
    
    
    // MARK: - Actions
    @IBAction func camreButtonPressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                    present(picker, animated: true, completion: nil)
                } else {
                    print("Kamera kullanılabilir değil.")
                }
    }
}
