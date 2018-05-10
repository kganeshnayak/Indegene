//
//  IDImageViewController.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class IDImageViewController: UIViewController {

    var imageUrl:String? = ""
    @IBOutlet weak var asyncImageView: IDAsyncImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    func initialSetup() {
        asyncImageView.loadImage(urlString: imageUrl!)
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
