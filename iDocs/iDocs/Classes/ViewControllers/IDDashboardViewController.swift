//
//  IDDashboardViewController.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

enum Layout: Int {
    case grid = 1
    case list = 2
}

class IDDashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var contents:[Content]? = nil
    var layoutType:Layout = .grid
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dashboardViewModel = IDDashboardViewModel()
        
        do {
            contents = try dashboardViewModel.loadContent()
            itemCollectionView.reloadData()
        } catch { }
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: GeneralConstants.kIDMainStoryboard, bundle: nil)
        let imageController = mainStoryboard.instantiateViewController(withIdentifier: GeneralConstants.kIDSettingsControllerIdentifier) as! IDSettingsViewController
        self.navigationController?.pushViewController(imageController, animated: true)
    }
    
    @IBAction func toggleLayout(_ sender: Any) {
        layoutType = Layout(rawValue: (sender as AnyObject).tag!)!
        itemCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let cnt = contents
        {
            return cnt.count
        }
        else {return 0 }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        if layoutType == .grid {
            width = collectionView.bounds.width/2 - (10 * 2)
        }
        let height = (width * 3)/4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let content =  contents![indexPath.item]
        switch content.contentType {
        case .image(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralConstants.kIDImageCellIdentifier, for: indexPath) as! IDImageCollectionViewCell
            cell.updateView(with: url)
            return cell
        case .pdf(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralConstants.kIDPdfCellIdentifier, for: indexPath) as! IDPDFCollectionViewCell
            cell.updateView(with: url)
            return cell
        case .video(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralConstants.kIDVideoCellIdentifier, for: indexPath) as! IDVideoCollectionViewCell
            cell.updateView(with: url)
            return cell
        }
    }
    
    func navigateToImageDeatailScreen(url: String) {
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: GeneralConstants.kIDMainStoryboard, bundle: nil)
        let imageController = mainStoryboard.instantiateViewController(withIdentifier: GeneralConstants.kIDImageControllerIdentifier) as! IDImageViewController
        imageController.imageUrl = url
        self.navigationController?.pushViewController(imageController, animated: true)
    }
    
    func navigateToPDFDeatailScreen(url: String) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: GeneralConstants.kIDMainStoryboard, bundle: nil)
        let pdfViewController = mainStoryboard.instantiateViewController(withIdentifier: GeneralConstants.kIDPdfControllerIdentifier) as! IDPdfViewController
        pdfViewController.pdfUrl = url
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
    func navigateToVideoDeatailScreen(url: String) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: GeneralConstants.kIDMainStoryboard, bundle: nil)
        let videoViewController = mainStoryboard.instantiateViewController(withIdentifier: GeneralConstants.kIDVideoControllerIdentifier) as! IDVideoViewController
        videoViewController.videoURL = url
        self.navigationController?.pushViewController(videoViewController, animated: true)
    }

    /*
     Collection View delegate, for navigating to the specific detail screen based on content type.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content =  contents![indexPath.item]

        switch content.contentType {
        case .image(let url):
            navigateToImageDeatailScreen(url: url)
        case .pdf(let url):
            navigateToPDFDeatailScreen(url: url)
        case .video(let url):
            navigateToVideoDeatailScreen(url: url)
        }
    }
        
}
