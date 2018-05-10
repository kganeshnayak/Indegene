//
//  IDWebserviceManager.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

extension UInt32 {
    func randomNumber() -> UInt32 {
        var randomNumber = arc4random_uniform(10)
        while self == randomNumber {
            randomNumber = arc4random_uniform(10)
        }
        return randomNumber
    }
}

class IDWebserviceManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    var completion:ServiceResponse? = nil
    let fileManager = IDFileManager()

    /*
     Returns URLSessionConfiguration object.
     */
    func makeSessionConfiguration() -> URLSessionConfiguration {
        let sessionNumber = Int(UInt32(50).randomNumber())
        let configuration = URLSessionConfiguration.background(withIdentifier: "Session\(sessionNumber)")
        configuration.isDiscretionary = true
        configuration.sessionSendsLaunchEvents = true
        configuration.timeoutIntervalForRequest = 30.0;
        configuration.timeoutIntervalForResource = 60.0;
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return configuration
    }
    
    /*
     Gets session object.
     */
    var session : URLSession {
        get {
            let config = makeSessionConfiguration()
            return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        }
    }

    /*
     Request entry point, here the completion handler is caled if the file for the external url is retrieved from the saved cache or
     it is downloaded using URLSession downloadtask.
     */
    func download(urlString:String, completionHandler:@escaping ServiceResponse) {
        let url = URL(string: urlString)!

        if let savedPath = fileManager.savedPath(for: url) {
            completionHandler(savedPath)
            return
        }
        let task = session.downloadTask(with: url)
        completion = completionHandler
        task.resume()
    }
    
    /*
     In this URLSession delegate method, the file is downloaded and saved to the local cache. The completion handler called to
     indicate the download ended.
     */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        
        if let savedPath = fileManager.updateFileAndSaveIfDoesNotExist(at: location, url: url) {
            completion!(savedPath)
        }
    }
    
    /*
     In this URLSession delegate method, after the app is re launched in the background, the event is handled in the back ground and upon completion the provided completion handler is invoked.
     */
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }

}
