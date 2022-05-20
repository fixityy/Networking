//
//  NetworkManager.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import Foundation
import UIKit

class NetworkManager {
    
    static func fetchCourseData(completionHandler: @escaping (([Course])->())) {
        guard let url = URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                completionHandler(courses)
            } catch let error1 {
                print(error1.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchImage(url: String, completionHandler: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession(configuration: .ephemeral)
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completionHandler(image)
            }
        }.resume()
    }
    
    static func getRequest(url: String) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            
            guard let response = response, let data = data else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    static func postRequest(url: String) {
        let userData = ["First": "First data", "Second": "Second data"]
        
        guard let url = URL(string: url) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let response = response, let data = data else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func uploadImage(url: String, image: UIImage?, completion: @escaping ()->()) {
        guard let image = image else { return }
        let httpHeaders = ["Authorization": "Client-ID 506876ef27d667a"]
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
                
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    completion()
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


