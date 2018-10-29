//
//  WebViewController.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 15/10/2018.
//  Copyright © 2018 Youngwoo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webPage: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        guard let url = URL(string: webURL) else {return}
        let request = URLRequest(url: url)
        webPage.load(request)
        // Do any additional setup after loading the view.
    }
    @IBAction func onClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
