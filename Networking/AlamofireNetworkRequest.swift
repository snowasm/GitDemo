//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Александр on 19.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    static var onProgress: ((Double)->())?
    static var completed: ((String)->())?
    
    static func sendRequest(url: String, competition: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                guard let courses = Course.getCourses(from: value) else { return }
                competition(courses)
                
            case .failure(let error):
                print(error.errorDescription ?? "error")
            }
        }
        
    }
    
    static func sendRequest1(url: String, competition: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseData { response in
            
            switch response.result {
            case .success(let value):
                 do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let courses = try decoder.decode([Course].self, from: value)
                        competition(courses)
                    } catch let error {
                        print(error)
                    }
            case .failure(let error):
                print(error.errorDescription ?? "error")
            }
        }
        
    }
    
    
    static func downloadImage(url: String, completition: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        AF.request(url).responseData{ responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completition(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    static func downloadImageWithProgress(url: String, completition: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().downloadProgress{ progress in
            print("Всего грузим :\(progress.totalUnitCount)")
            print("Загрузили :\(progress.completedUnitCount)")
            print("Типа процент :\(progress.fractionCompleted)")
            print("Описание :\(progress.localizedDescription!)")
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription!)
        }.response{ data in
            switch data.result {
            case .success(let data):
                guard let data = data, let image = UIImage(data: data) else { return }
                completition(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    static func postRequest(url: String, competition: @escaping (_ courses: [Course])->()) {
        guard let url = URL(string: url) else { return }
        let userData: [String: Any] = ["name": "Network Request",
                                        "link": "https://swiftbook.ru/contents/our-first-applications/",
                                "imageUrl": "https://swiftbook.ru/wp-content/uploads/2018/03/13-courselogo.jpg",
                                    "number_of_lessons": 20,
                                    "number_of_tests": 10]
        
        AF.request(url, method: .post, parameters: userData).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            print(statusCode)
            
            switch response.result {
            case .success(let data):
                print(data)
                guard
                    let jsonObject = data as? [String: Any],
                    let course = Course.init(json: jsonObject)
                else { return }
                var courses = [Course]()
                courses.append(course)
                competition(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    static func putRequest(url: String, competition: @escaping (_ courses: [Course])->()) {
           guard let url = URL(string: url) else { return }
           let userData: [String: Any] = ["name": "Network Request (New)",
                                           "link": "https://swiftbook.ru/contents/our-first-applications/",
                                   "imageUrl": "https://swiftbook.ru/wp-content/uploads/2018/03/13-courselogo.jpg",
                                       "number_of_lessons": 20,
                                       "number_of_tests": 10]
           
           AF.request(url, method: .put, parameters: userData).responseJSON { (response) in
               guard let statusCode = response.response?.statusCode else { return }
               print(statusCode)
               
               switch response.result {
               case .success(let data):
                print(data)
                   guard
                       let jsonObject = data as? [String: Any],
                       let course = Course.init(json: jsonObject)
                   else { return }
                   var courses = [Course]()
                   courses.append(course)
                   competition(courses)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    
    static func uploadImage(url: String) {
//        guard let url = URL(string: url) else { return }
//        guard let image = UIImage(named: "13-courselogo") else { return }
//        guard let data = image.pngData() else { return }
//
//        let httpHeaders = ["Authorization" : "Client-ID de0976da00e2047"]
//
//
        
//        AF.upload(multipartFormData: { (multipartForData) in
//            multipartForData.append(data, withName: "image")
//        }, to: url, headers: httpHeaders)
//        AF.upload
//        AF.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(data, withName: "image")
//        },
//           to: url,
//           method: .post
//           headers: httpHeaders).responseJSON { (response) in
//            switch response.result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error)
//            }
//        }
//
        print("Dev it soon")
        print("may be..")
        print("remote change")
        
        print("may be..?")
        
    }
    
    
}
