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
}
