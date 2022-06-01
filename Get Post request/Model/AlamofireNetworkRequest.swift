//
//  AlamofireNetworkRequest.swift
//  Get Post request
//
//  Created by Roman Belov on 24.05.2022.
//

import Foundation
import Alamofire
import CoreText

class AlamofireNetworkRequest {
    
    static var onProgress: ((Double)->())?
    static var completed: ((String)->())?
    
    static func sendRequest(url: String, completionHandler: @escaping (([Course])->())) {
        
        guard let url = URL(string: url) else { return }
        
//        request(url).responseJSON { response in
//
//            guard let statusCode = response.response?.statusCode else { return }
//
//            print("Status code: \(statusCode)")
//
//            if (200..<300).contains(statusCode) {
//                let value = response.result.value
//                print("Value: ", value ?? "nil")
//            } else {
//                let error = response.result.error
//                print("Error: ", error ?? "Error")
//            }
//        }
        
        request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let courses = Course.getArray(from: value)!
                
                completionHandler(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchImageWithAlamofire(url: String, completionHandler: @escaping (_ image: UIImage)->()) {

        guard let url = URL(string: url) else { return }
        
        request(url).validate().responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completionHandler(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchData(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        request(url).responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                        print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchStringData(url: String) {
        guard let url = URL(string: url) else { return }

        request(url).responseString(encoding: .utf8) { stringDataResponse in
            
            switch stringDataResponse.result {
            case .success(let stringData):
                print(stringData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func response(url: String) {
        guard let url = URL(string: url) else { return }

        request(url).response { response in
            guard let data = response.data, let string = String(data: data, encoding: .utf8) else { return }
            print(string)
        }
    }
    
    static func downloadImageWithProgress(url: String, completionHandler: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        
        request(url).validate().downloadProgress { progress in
            print("Total unit count: \(progress.totalUnitCount)")
            print("Completed unit count: \(progress.completedUnitCount)")
            print("Fraction compleeted: \(progress.fractionCompleted)")
            print("Localized description: \(progress.localizedDescription!)")
            print("-------------------------------")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription!)
        }.response { response in
            guard let data = response.data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
}
