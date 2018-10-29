//
//  SettingAddress.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 11..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

import UIKit

class SettingAddress: UIViewController {

    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBAction func gotoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func OnClick(_ sender: Any) {
        if (addressInput.text != "") {
            myAddress.phoneNumber = addressInput.text!
        }
        if (emailInput.text != "") {
            myAddress.emailAddress = emailInput.text!
        }
        
        performSegue(withIdentifier: "GotoHome", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
