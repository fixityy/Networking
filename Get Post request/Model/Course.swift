//
//  Course.swift
//  Get Post request
//
//  Created by Roman Belov on 16.05.2022.
//

import Foundation

struct Course: Codable {
    let id: Int
    let name: String
    let link: String
    let imageURL: String
    let numberOfLessons, numberOfTests: Int

    enum CodingKeys: String, CodingKey {
        case id, name, link
        case imageURL = "imageUrl"
        case numberOfLessons = "number_of_lessons"
        case numberOfTests = "number_of_tests"
    }
    
    
    // init for alamofire
    init?(json: [String: Any]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageURL = json["imageUrl"] as? String
        let numberOfLessons = json["number_of_lessons"] as? Int
        let numberOfTests = json["number_of_tests"] as? Int
        
        self.id = id!
        self.name = name!
        self.link = link!
        self.imageURL = imageURL ?? ""
        self.numberOfLessons = numberOfLessons ?? 0
        self.numberOfTests = numberOfTests ?? 0
    }
    
    static func getArray(from jsonArray: Any) -> [Course]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        
//        var courses = [Course]()
//
//        for jsonObject in jsonArray {
//            if let course = Course(json: jsonObject) {
//                courses.append(course)
//            }
//        }
//
//        return courses
        
        return jsonArray.compactMap {Course(json: $0)}
    }
}
