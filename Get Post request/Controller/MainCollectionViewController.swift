//
//  MainCollectionViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 19.05.2022.
//

import UIKit
import NotificationCenter
import Alamofire

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {

//    let actions = ["Download Image", "GET", "Post", "SwiftBook courses", "Upload Image"]
    private let actions = Actions.allCases
    private let url = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImageURL = "https://api.imgur.com/3/image"
    private let swiftBookURL = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let dataProvider = DataProvider()
    private var filePath: String?
    private var alert = UIAlertController()
    
    enum Actions: String, CaseIterable {
        case downloadImage = "Download Image"
        case get = "GET"
        case post = "POST"
        case swiftBookCourses = "SwiftBook courses"
        case uploadImage = "Upload Image"
        case downloadFile = "Download File"
        case swiftBookCoursesAlamofire = "SwiftBook courses Alamofire"
        case downloadImageAlamofire = "Download Image Alamofire"
        case dataAlamofire = "Data Alamofire"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        dataProvider.fileLocation = { location in
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.postNotification()
            self.alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(){
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            self.dataProvider.stopDownload()
        })
        alert.addAction(action)
        
        alert.view.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        present(alert, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .systemBlue
            
            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
                if progress == 1 {
                    self.alert.dismiss(animated: true, completion: nil)
                }
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
            
            
        }
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
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .swiftBookCoursesAlamofire:
            performSegue(withIdentifier: "ToTableVCAlamofire", sender: nil)
        case .downloadImageAlamofire:
            performSegue(withIdentifier: "ToImageVCAlamofire", sender: nil)
        case .dataAlamofire:
//            AlamofireNetworkRequest.fetchData(url: swiftBookURL)
//            AlamofireNetworkRequest.fetchStringData(url: swiftBookURL)
            AlamofireNetworkRequest.response(url: swiftBookURL)
        }
    }
    
    //подготавливаем переход на Вью контроллер с курсами
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? TableViewController
        
        switch segue.identifier {
        case "ToTableVC":
            coursesVC?.fetchData()
        case "ToTableVCAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        default: break
        }
        
        let imageVC = segue.destination as? SecondViewController
        
        switch segue.identifier {
        case "ToImageVC":
            imageVC?.fetchImage()
        case "ToImageVCAlamofire":
            imageVC?.fetchImageWithAlamofire()
        default: break
        }
    }

}

extension MainCollectionViewController {
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = " Your background transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
