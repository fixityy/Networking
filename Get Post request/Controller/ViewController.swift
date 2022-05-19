//
//  ViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let url = "https://jsonplaceholder.typicode.com/posts"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getButton(_ sender: Any) {
        NetworkManager.getRequest(url: url)
    }
    
    @IBAction func postButton(_ sender: Any) {
        NetworkManager.postRequest(url: url)
    }
}

