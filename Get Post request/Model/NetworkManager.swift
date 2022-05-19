//
//  NetworkManager.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import Foundation

class NetworkManager {
    
    func fetchCourseData(completionHandler: @escaping (([Course])->())) {
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
}


