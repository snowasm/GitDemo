//
//  Course.swift
//  Networking
//
//  Created by Александр on 15.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import Foundation

/* URLSession
struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
*/

struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    init?(json: [String: Any]) {
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.link = json["link"] as? String
        self.imageUrl = json["imageUrl"] as? String
        self.numberOfLessons = json["number_of_lessons"] as? Int
        self.numberOfTests = json["number_of_tests"] as? Int
    
    }
    
    static func getCourses(from json: Any) -> [Course]? {
        guard let arrayOfItems = json as? Array<[String: Any]> else { return nil }
//        var courses = [Course]()
//        for field in arrayOfItems {
//            if let course = Course(json: field) {
//                courses.append(course)
//            }
//        }
//        return courses
        return arrayOfItems.compactMap{ Course(json: $0)}
    }
    
    
}
