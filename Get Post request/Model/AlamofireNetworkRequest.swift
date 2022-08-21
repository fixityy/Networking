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
    
    static func postRequest(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name": "Network Request", "link": "https://swiftbook.ru/content/24-index/", "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2019/04/10-course-copy-8.png", "number_of_lessons": 18, "number_of_tests": 10]
        
        request(url, method: .post, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            
            print(statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                
                guard let jsonObject = value as? [String: Any], let course = Course(json: jsonObject) else {return}
                
                var courses = [Course]()
                courses.append(course)
                
                completionHandler(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func putRequest(url: String, completionHandler: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name": "Network Request Alamafire", "link": "https://swiftbook.ru/content/24-index/", "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2019/04/10-course-copy-8.png", "number_of_lessons": 18, "number_of_tests": 10]
        
        request(url, method: .put, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            
            print(statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                
                guard let jsonObject = value as? [String: Any], let course = Course(json: jsonObject) else {return}
                
                var courses = [Course]()
                courses.append(course)
                
                completionHandler(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func uploadImage(url: String, image: UIImage?) {
        
        guard let url = URL(string: url), let image = image, let data = image.pngData() else { return }
        
        let httpHeaders = ["Authorization": "Client-ID 506876ef27d667a"]
        
        upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(data, withName: "image")

        }, to: url, method: .post, headers: httpHeaders) { encodingCompletion in
            
            switch encodingCompletion {
            case .success(request: let uploadRequest, streamingFromDisk: let streamingFromDisk, streamFileURL: let streamFileURL):
                print(uploadRequest)
                print(streamingFromDisk)
                print(streamFileURL ?? "streamFileURL is nil")
                
                uploadRequest.validate().responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
