//
//  IDVideoViewController.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class IDVideoViewController: UIViewController {
    
    var videoURL: String = ""
    private var playerView = AVPlayerViewController()
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    private func initialSetup() {
        view.addSubview(playerView.view)
        addVideoPlayer()
    }
    
    private func addVideoPlayer() {
        if playerView.player?.status != .readyToPlay {
            guard let url = URL(string: videoURL) else {
                return
            }
            let player = AVPlayer(url: url)
            playerView.player = player
            playerView.view.frame = CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height)
            playerView.player?.play()
        }
    }
}
