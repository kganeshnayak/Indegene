//
//  IDFileManager.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import Foundation

enum Location: Int {
    case Document = 0
    case Library = 1
}

protocol ContentFileManager {
    func savedPath(for url: URL) -> URL?
    func updateFileAndSaveIfDoesNotExist(at localPath: URL, url: URL) -> URL?
}

class IDFileManager: ContentFileManager {
    let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    /*
     Saves the file to the local cache.
     */
    func updateFileAndSaveIfDoesNotExist(at localPath: URL, url: URL) -> URL? {
        do {
            guard let savedURL = path(from: url) else { return nil }
            deleteFile(at: savedURL)
            try fileManager.moveItem(at: localPath, to: savedURL)
            self.deleteFile(at: localPath)
            return savedURL
        } catch {
            print ("file error: \(error)")
        }
        return nil
    }
    
    /*
     Deletes the local file from local path.
     */
    private func deleteFile(at location: URL) {
        if fileManager.fileExists(atPath: location.absoluteString) {
            try? fileManager.removeItem(at: location)
        }
    }
    
    /*
     Checks the external url for the last string after "=" sign and prefixes it with the local cache path and returns it.
     */
    private func path(from url: URL) -> URL? {
        do {
            let prefs = UserDefaults.standard
            let locationType:Location = Location(rawValue: prefs.integer(forKey: GeneralConstants.kIDStoreLocation))!
            let documentsURL:URL
            
            switch locationType {
            case .Document:
                documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            case .Library:
                documentsURL = try fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            }
            
            guard let queryString = url.query else { return nil }
            let queryArray = queryString.components(separatedBy: "=") as [String]
            var nameStr : String?
            if queryArray.count > 1 {
                nameStr = queryArray[1]
            }
            else
            {
                nameStr = nil
            }

            guard let uniqueComponent = nameStr else { return nil }
            let savedURL = documentsURL.appendingPathComponent(uniqueComponent)
            return savedURL
        } catch {
            print("URL is not valid")
        }
        return nil
    }
    
    /*
     Gets the saved path of the files from local cache, for the specific external file url.
     */
    func savedPath(for url: URL) -> URL? {
        guard let filePath = path(from: url) else {
            return nil
        }
        let isExist = fileManager.fileExists(atPath: filePath.path)
        if isExist {
            return filePath
        }
        return nil
    }
}
