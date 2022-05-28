//
//  SecondViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let activity = UIActivityIndicatorView()
    let url = "https://i.ibb.co/2gPL6WV/B391-AA7-A-EDDE-4-EFC-856-A-B941119290-AE.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        createActivityIndicator()
    }
    
    private func createActivityIndicator() {
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        view.addSubview(activity)
    }
    
    func fetchImage() {
        NetworkManager.fetchImage(url: url) { image in
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.imageView.image = image
            }
        }
    }
    
    func fetchImageWithAlamofire() {
        AlamofireNetworkRequest.fetchImageWithAlamofire(url: url) { image in
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.imageView.image = image
            }
        }
    }
    
    

}
