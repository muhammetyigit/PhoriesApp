//
//  PhoriesCollectionViewController.swift
//  PhoriesApp
//
//  Created by Muhammet Yiğit on 16.04.2025.
//

import UIKit
import CoreLocation
import CoreData

private let reuseIdentifier = "Cell"

class PhoriesCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    var photos = [Photo]()
    let locationManager = CLLocationManager()
    var selectedItem: IndexPath?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isEditingMode = false
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        load()
    }
    
    // MARK: UICollectionView DataSource & Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell

        if let imageData = photos[indexPath.row].binaryPhoto {
            let image = UIImage(data: imageData)
            cell.imageView.image = image
        }

        // ✅ Yeni animasyonlu görünürlük
        cell.setDeleteButtonVisibility(isEditingMode)

        // Action ekle
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath
        performSegue(withIdentifier: "detailPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailphotoViewController
        if let indexPath = selectedItem {
            destinationVC.photo = photos[indexPath.row]
        }
    }
    
    // Hücre boyutu
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (itemsPerRow - 1)
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        return CGSize(width: width, height: width)
    }

    // Satır arası dikey boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Hücreler arası yatay boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Kenar boşlukları
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - HeadingUIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                getLocation { adres in
                    if let adres = adres {
                        print("Adres: \(adres)")
                        
                        let newPhories = Photo(context: self.context)
                        newPhories.binaryPhoto = imageData
                        newPhories.adress = adres

                        self.photos.append(newPhories)
                        self.saveItems()
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } else {
                        print("Adres alınamadı.")
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // İptal edilirse
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func getLocation(completion: @escaping (String?) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            if let location = locationManager.location {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let placemark = placemarks?.first,
                       let city = placemark.locality,
                       let district = placemark.subLocality {
                        let fullAddress = "\(city)/\(district)"
                        completion(fullAddress)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("❌ Core Data kayıt edilemedi: \(error.localizedDescription)")
        }
    }
    
    func load() {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        do {
            photos = try context.fetch(request)
            print("📸 Core Data'dan \(photos.count) kayıt yüklendi.")
        } catch {
            print("❌ Core Data'dan veri çekilemedi: \(error.localizedDescription)")
        }
        collectionView.reloadData()
    }
    
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
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditingMode.toggle()
        print("Edit Mode: \(isEditingMode)")
        collectionView.reloadData()
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let photoToDelete = photos[index]
        context.delete(photoToDelete)
        photos.remove(at: index)
        saveItems()
        collectionView.reloadData()
    }
}
