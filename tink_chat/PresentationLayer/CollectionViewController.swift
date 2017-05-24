//
//  CollectionViewController.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeImage {
    func chooseImage(image: UIImage)
}

class CollectionViewController: UICollectionViewController {
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let reuseIdentifier = "photoCell"
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate var searches = [ApiImage]()
    
    let collectionModel = CollectionModel()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var imageArray: [UIImage?]?
    
    var delegate: ChangeImage?
    
    let queue = DispatchQueue.global(qos: .userInitiated)
    
    override func viewDidLoad() {
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionModel.getPictures { (images, error) in
                if let imag = images {
                    self.searches = imag
                    self.imageArray = Array(repeating: nil, count: (self.searches.count))
                    self.collectionView?.reloadData()
                    self.indicator.stopAnimating()
                } else {
                    print(error)
                    let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ImageCell
        
        if let oldImage: UIImage = imageArray?[indexPath.row] {
            cell.imageView.image = oldImage
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "noimage")
            downloadImage(indexPath: indexPath, cell: cell)
        }
        // Configure the cell
        return cell
    }
    
    func downloadImage(indexPath: IndexPath, cell: ImageCell) {
        
        queue.async {
            
            do{
                let url = URL(string: self.searches[indexPath.row].imageURL)
                let imageData = try Data(contentsOf: url!)
                
                var image: UIImage?
                
                if imageData != nil {
                    image = UIImage(data: imageData)
                }
                if let im = image {
                    self.imageArray?[indexPath.row] = im
                }
                //let cell = self.collectionView?.cellForItem(at: indexPath) as! ImageCell
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            } catch {
                print(error)
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        delegate?.chooseImage(image: imageArray![indexPath.row]!)
        dismiss(animated: true, completion: nil)
        
        return true
    }
}



extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
