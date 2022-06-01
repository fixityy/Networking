//
//  SecondViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let activity = UIActivityIndicatorView()
    let url = "https://i.ibb.co/2gPL6WV/B391-AA7-A-EDDE-4-EFC-856-A-B941119290-AE.jpg"
    let largeImageURL = "https://effigis.com/wp-content/uploads/2015/02/DigitalGlobe_QuickBird_60cm_8bit_RGB_DRA_Boulder_2005JUL04_8bits_sub_r_1.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        createActivityIndicator()
        progressView.isHidden = true
        progressLabel.isHidden = true
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
    
    func downloadLargeImageWithAlamofire() {

        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { completed in
            self.progressLabel.isHidden = false
            self.progressLabel.text = completed
        }
        
        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageURL) { image in
            self.activity.stopAnimating()
            self.progressLabel.isHidden = true
            self.progressView.isHidden = true
            self.imageView.image = image
        }
    }

}
