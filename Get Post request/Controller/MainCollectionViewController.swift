//
//  MainCollectionViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 19.05.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {

//    let actions = ["Download Image", "GET", "Post", "SwiftBook courses", "Upload Image"]
    let actions = Actions.allCases
    let url = "https://jsonplaceholder.typicode.com/posts"
    let uploadImageURL = "https://api.imgur.com/3/image"
    
    enum Actions: String, CaseIterable {
        case downloadImage = "Download Image"
        case get = "GET"
        case post = "POST"
        case swiftBookCourses = "SwiftBook courses"
        case uploadImage = "Upload Image"
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.actionLabel.text = actions[indexPath.row].rawValue
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.backgroundColor = .white
            cell?.backgroundColor = .systemYellow
        }
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ToImageVC", sender: nil)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .swiftBookCourses:
            performSegue(withIdentifier: "ToTableVC", sender: nil)
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadImageURL, image: UIImage(named: "TestImage")) {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: nil, message: "Image uploaded", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
