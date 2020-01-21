//
//  DataProvider.swift
//  Networking
//
//  Created by Александр on 16.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    var fileLoacation: ((URL)->())?
    var onProgress: ((Double)->())?
    
    private var downloadTask: URLSessionDownloadTask!
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "snow.Networking")
//        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    func startDownload() {
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(0)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
    
}

extension DataProvider: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completitonHandler = appDelegate.bgSessionCompletitonHandler
                else { return }
            appDelegate.bgSessionCompletitonHandler = nil
            completitonHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finish download")
        DispatchQueue.main.async {
            self.fileLoacation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {
            return
        }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Progress: \(progress)")
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
