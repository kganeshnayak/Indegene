//
//  IDVideoCollectionViewCell.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import AVFoundation

class IDVideoCollectionViewCell: UICollectionViewCell {
    let dashboardViewModel = IDDashboardViewModel()
    @IBOutlet weak var videoImageView: UIImageView!
    
    /*
     Updates Video Cell.
     */

    func updateView(with url: String) {
        dashboardViewModel.downloadFiles(withUrlString: url) { (url) in
            guard let filePath = url else {
                return
            }
            DispatchQueue.main.async {
                self.videoImageView.image = self.getThumbnailImage(for: filePath as! URL)
            }
        }
    }

    func getThumbnailImage(for url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
}
