//
//  IDDashboardViewModel.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import Foundation

typealias Json = [String: Any]

enum JSONLoaderError: Error {
    case loadJSONFileError(message: String)
    case parseJSONError(message: String)
}

enum JSONParserError: Error {
    case jsonError(message: String)
}

class IDDashboardViewModel : NSObject
{
    /*
     Downloads the files then invokes the completion handler after completing the download.
     */
    func downloadFiles(withUrlString: String, completion: @escaping(ServiceResponse)) {
        
        let webServiceManager = IDWebserviceManager()
        
        webServiceManager.download(urlString: withUrlString, completionHandler: { (locaton) in
            completion(locaton)
        })
    }

    /*
     Loads the json content stored in file.
     */
    func loadContent() throws -> [Content] {
        let jsonContent = try loadJSON(name: GeneralConstants.kIDContent)
        guard let contents = jsonContent[GeneralConstants.kIDContent] as? [Json] else {
            throw JSONParserError.jsonError(message: "Key for content might have changed")
        }
        return contents.map({ dict -> Content? in do { return try Content(json: dict) } catch { return nil }}).flatMap { $0 }
    }

    /*
     Json object is returned by loading json data from the specified file.
     */
    func loadJSON(name: String) throws -> Json {
        let data = try loadFile(name: name, ofType: GeneralConstants.kIDTypeJson)
        guard let json = (try JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            throw JSONLoaderError.parseJSONError(message: "Couldn't parse JSON file named \(name).json")
        }
        return json
    }

    /*
     Gets the NSData from the specified file.
     */
    private func loadFile(name: String, ofType type: String) throws -> Data {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: name, ofType: type),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                let message: String
                if let bundleIdentifier = bundle.bundleIdentifier {
                    message = "Couldn't load file named \(name).\(type) in bundle \(bundleIdentifier)"
                } else {
                    message = "Couldn't load file named \(name).\(type)"
                }
                throw JSONLoaderError.loadJSONFileError(message: message)
        }
        return data
    }
}
