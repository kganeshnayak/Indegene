//
//  IDSettingsViewController.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class IDSettingsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = UserDefaults.standard
        let locationType:Location = Location(rawValue: prefs.integer(forKey: GeneralConstants.kIDStoreLocation))!
        
        switch locationType {
        case .Document:
            segmentedControl.selectedSegmentIndex = 0;
        case .Library:
            segmentedControl.selectedSegmentIndex = 1;
        }
    }

    /*
     Stores segmented control state in uaer defaults that determines the location for storing files locally.
     */
    @IBAction func segmentedButtonTapped(_ sender: Any) {
        let prefs = UserDefaults.standard
        prefs.set(segmentedControl.selectedSegmentIndex, forKey: GeneralConstants.kIDStoreLocation)
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
