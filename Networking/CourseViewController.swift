//
//  CourseViewController.swift
//  Networking
//
//  Created by Александр on 15.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {

    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    private let urlApi = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let urlPost = "https://jsonplaceholder.typicode.com/posts"
    private let putRequestURL = "https://jsonplaceholder.typicode.com/posts/1"

    @IBOutlet weak var tableView1: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fetchData() {
        NetworkManager.fetchData(url: urlApi) {courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
        }
    }
    
    func fetchDataAF()
    {
        AlamofireNetworkRequest.sendRequest1(url: urlApi) {courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
        }
    }
    
    func postRequest() {
        AlamofireNetworkRequest.postRequest(url: urlPost) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
        }
    }
    
    func putRequest() {
        AlamofireNetworkRequest.putRequest(url: putRequestURL) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
        }
    }
   
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        else {
            cell.numberOfLessons.text = "Number of lessons: 0"
        }
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        else {
            cell.numberOfTests.text = "Number of tests: 0"
        }
        
        DispatchQueue.global().async {
            guard
                let imageString = course.imageUrl,
                let imgUrl = URL(string: imageString)
                else {
                return
            }
            guard let imageData = try? Data(contentsOf: imgUrl) else {return}
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        if let url = courseURL {
            webViewController.courseURL = url
        }
    }
    
}



// MARK: Table Data Source
extension CourseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
}


// MARK: Table View Delegate

extension CourseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }
}
