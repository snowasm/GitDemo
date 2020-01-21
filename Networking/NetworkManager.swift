//
//  NetworkManager.swift
//  Networking
//
//  Created by Александр on 16.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class NetworkManager {
    
    
    static func getRequest(url: String) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        else {
            return
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }catch {
                print(error)
            }
            
        }.resume()
    }
    
    static func postRequest(url: String) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        else {
                return
        }
        let userData = ["Course" : "Networking", "Lesson" : "GET and POST Requests"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: [])
        else {
                return
        }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else {
                return
            }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }catch {
                print(error)
            }
        }.resume()
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
        } .resume()
    }
    
    static func fetchData(url: String, competition: @escaping (_ courses: [Course])->()) {
        //        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_course"
//                let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
        //        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
        //        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
                guard let url = URL(string: url) else {return}
                let session = URLSession.shared
                session.dataTask(with: url) { (data, _, _) in
                    guard let data = data else {return}
                    print(data)
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let courses = try decoder.decode([Course].self, from: data)
                        competition(courses)
                    } catch let error {
                        print(error)
                    }
                }.resume()
    }
    
    static func uploadImage(url: String) {
        guard let image = UIImage(named: "13-courselogo") else { return }
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else {return}
        
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let httpHeaders = ["Authorization" : "Client-ID de0976da00e2047"]
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
}
