//
//  IDContentModel.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import Foundation

enum KeyError: Error {
    case keyDoesNotMatch
}

enum Type: String {
    case image
    case pdf
    case video
}

enum ContentType {
    case image(String)
    case pdf(String)
    case video(String)
    
    func url() -> String {
        switch self {
        case .image(let url):
            return url
        case .pdf(let url):
            return url
        case .video(let url):
            return url
        }
    }
}

protocol JsonInitialiable {
    init(json: Json) throws
}

/*
 Json content is initialized in this strcut.
 */

struct Content: JsonInitialiable {
    let contentType: ContentType
    
    init(json: Json) throws {
        
        guard let typeSring = json[GeneralConstants.kIDTypeKey] as? String,
            let type = Type(rawValue: typeSring),
            let url = json[GeneralConstants.kIDUrlKey] as? String else {
            throw KeyError.keyDoesNotMatch
        }

        switch type {
        case .image:
            contentType = .image(url)
        case .pdf:
            contentType = .pdf(url)
        case .video:
            contentType = .video(url)
        }
    }
}

