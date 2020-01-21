//
//  MainViewController.swift
//  Networking
//
//  Created by Александр on 16.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

private let reuseIdentifier = "Cell"

private enum Actions: String, CaseIterable {
    case downloadImage = "Download img"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our courses"
    case uploadImage = "Upload img"
    case downloadFile = "Download file"
    case ourCoursesAl = "Our courses(Al)"
    case downloadImageAF = "ShowImageAF"
    case downloadImagePR = "ShowImagePR"
    case postAlamofire = "PostAF"
    case putAlamofire = "PUT AF"
    case uploadImageAF = "UploadImage AF"
}

class MainViewController: UICollectionViewController {
//    let actions = ["Download img", "GET", "POST", "Our courses", "Upload img"]
    private let dataProvider = DataProvider()
    private var filePath: String?
    private let actions = Actions.allCases
    private var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registrationForNatification()
        
        dataProvider.fileLoacation = {(path) in
            self.filePath = path.absoluteString
            print(path.absoluteString)
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0 %", preferredStyle: .alert)
        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        
        
        let cancelAlert = UIAlertAction(title: "Отмена", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAlert)
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2,
                                y: self.alert.view.frame.height / 2 - size.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .green
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.height - 44,
                                                            width: self.alert.view.frame.width,
                                                            height: 2))
            progressView.tintColor = .red
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = "\(Int(progress * 100)) %"
            }
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .get:
            NetworkManager.getRequest(url: "")
        case .post:
            NetworkManager.postRequest(url: "")
        case .uploadImage:
            NetworkManager.uploadImage(url: "https://api.imgur.com/3/image")
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesAl:
            performSegue(withIdentifier: "OurCoursesAl", sender: self)
        case .downloadImageAF:
            performSegue(withIdentifier: "ShowImageAF", sender: self)
        case .downloadImagePR:
            performSegue(withIdentifier: "LargeImage", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "PostRequest", sender: self)
        case .putAlamofire:
            performSegue(withIdentifier: "putRequest", sender: self)
        case .uploadImageAF:
            AlamofireNetworkRequest.uploadImage(url: "https://api.imgur.com/3/image")
        }
    }
    

    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let courseVC = segue.destination as? CourseViewController
        let imageVC = segue.destination as? ImageViewController
        
        switch segue.identifier {
        case "OurCourses":
            courseVC?.fetchData()
        case "OurCoursesAl":
            courseVC?.fetchDataAF()
        case "ShowImage":
            imageVC?.fetchImage()
        case "ShowImageAF":
            imageVC?.fetchDataAF()
        case "LargeImage":
            imageVC?.downloadImageWithProgress()
        case "PostRequest":
            courseVC?.postRequest()
        case "putRequest":
            courseVC?.putRequest()
        default:
            break
        }
        
    }

    
    
}


extension MainViewController {
    
    private func registrationForNatification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in }

    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete"
        content.body = "File path \(filePath!)"
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Transfer complite", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
}
