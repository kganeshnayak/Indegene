//
//  IDImageCollectionViewCell.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class IDImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var asyncImageView: IDAsyncImageView!
    
    /*
     Updates Image Cell.
     */

    func updateView(with url: String) {
        self.activityIndicatorView.startAnimating()
        asyncImageView?.loadImage(urlString: url) { [weak self] in
            self?.activityIndicatorView.stopAnimating()
        }
    }
}
