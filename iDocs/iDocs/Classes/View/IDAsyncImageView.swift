//
//  IDAsyncImageView.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import Foundation
import UIKit

class IDAsyncImageView: UIImageView {
    let dashboardViewModel = IDDashboardViewModel()
        
    func reset() {
        self.image = nil
    }
    
    /*
     Loads its image with asybchronously downloaded image.
     */

    func loadImage(urlString: String, completion: (() -> Void)? = nil){
        dashboardViewModel.downloadFiles(withUrlString: urlString) { (url) in
            guard let filePath = url, let data = try? Data(contentsOf: filePath as! URL) else {
                return
            }
            DispatchQueue.main.async {
                completion?()
                let image = UIImage(data: data)
                self.image = image
            }
        }
    }
}

