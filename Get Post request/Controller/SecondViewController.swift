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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        createActivityIndicator()
        fetchImage()
    }
    
    private func createActivityIndicator() {
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        view.addSubview(activity)
    }
    
    private func fetchImage() {
        guard let url = URL(string: "https://i.ibb.co/2gPL6WV/B391-AA7-A-EDDE-4-EFC-856-A-B941119290-AE.jpg") else { return }
        
        let session = URLSession(configuration: .ephemeral)
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    self.imageView.image = image
                }
            }
        }.resume()
    }

}
