//
//  IDPdfViewController.swift
//  iDocs
//
//  Created by Ganesh Nayak on 10/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class IDPdfViewController: UIViewController, UIWebViewDelegate {

    var pdfUrl:String? = ""
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    func loadPdf(url:String) {
        guard let url = URL(string: url) else {
            return
        }
        webView.loadRequest(URLRequest(url: url))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPdf(url: pdfUrl!)
    }

    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicatorView.stopAnimating()
    }
}
