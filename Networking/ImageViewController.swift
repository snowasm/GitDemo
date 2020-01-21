//
//  ImageViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 27.07.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    private let urlImage = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let urlLargeImage = "https://i.imgur.com/3416rvI.jpg"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        progressLabel.isHidden = true
        progressBar.isHidden = true
        
    }
    
    func fetchImage() {
        
        NetworkManager.downloadImage(url: urlImage) { image in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            }
        }
        
    }
    
    func fetchDataAF() {
        AlamofireNetworkRequest.downloadImage(url: urlImage) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func downloadImageWithProgress() {
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressBar.isHidden = false
            self.progressBar.progress = Float(progress)
        }
        AlamofireNetworkRequest.completed = { completed in
            self.progressLabel.isHidden = false
            self.progressLabel.text = completed
        }
        AlamofireNetworkRequest.downloadImageWithProgress(url: urlLargeImage) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            self.progressBar.isHidden = true
            self.progressLabel.isHidden = true
        }
    }
    
    
    
}
