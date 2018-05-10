//
//  IDPDFCollectionViewCell.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import PDFKit

class IDPDFCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    let dashboardViewModel = IDDashboardViewModel()
    
    /*
     Updates Pdf Cell.
     */

    func updateView(with url: String) {
        self.activityIndicatorView.startAnimating()
        dashboardViewModel.downloadFiles(withUrlString: url) { (url) in
            guard let filePath = url else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                let thumbnailImage = self?.pdfThumbnail(url: filePath as! URL)
                self?.thumbnailImageView.image = thumbnailImage
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func pdfThumbnail(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url),
            let page = PDFDocument(data: data)?.page(at: 0) else {
                return nil
        }
        
        let width: CGFloat = bounds.width
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = width / pageSize.width
        
        // Apply if you're displaying the thumbnail on screen
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale, height: pageSize.height * scale)
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }

}
