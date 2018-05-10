//
//  iDocsTests.swift
//  iDocsTests
//
//  Created by IOS Developer on 08/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import XCTest
@testable import iDocs

class iDocsTests: XCTestCase {
    
    func testIfURLContentDownloadedAndSaved() {
        
        let imgUrl = "https://clientarea.indegene.com/sharemax/retrieve.jsp?id=93ac5b8a-69c1-44cd-803d-81701176ba3e"
        let dashboardViewModel = IDDashboardViewModel()
        dashboardViewModel.downloadFiles(withUrlString: imgUrl) { (url) in
            guard let filePath = url, let data = try? Data(contentsOf: filePath as! URL) else {
                return
            }


            do {
                let fileManager = FileManager.default

                let documentsURL = try
                    fileManager.url(for: .libraryDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)

                
                let fileUrl = NSURL(string: imgUrl)
                guard let queryString = fileUrl?.query else { return  }
                let queryArray = queryString.components(separatedBy: "=") as [String]
                var nameStr : String?
                if queryArray.count > 1 {
                    nameStr = queryArray[1]
                }
                else
                {
                    nameStr = nil
                }

                guard let uniqueComponent = nameStr else { return  }
                let savedURL = documentsURL.appendingPathComponent(uniqueComponent)

                XCTAssertEqual(savedURL, filePath as! URL)

            } catch {
                print("URL is not valid")
            }

            
        }

    }

}
