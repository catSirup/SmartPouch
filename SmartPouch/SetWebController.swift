//
//  SetWebController.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 16/10/2018.
//  Copyright © 2018 Youngwoo. All rights reserved.
//

import UIKit

class SetWebController: UIViewController {
    @IBOutlet weak var currentURL: UILabel!
    @IBOutlet weak var newURL: UITextField!
    @IBAction func gotoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        if (newURL.text != "") {
            webURL = newURL.text!
            currentURL.text = webURL
            
            let alertController = UIAlertController(title: "웹페이지 주소가 변경되었습니다",message: "", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
                self.okActions()
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "웹페이지 주소는 공백으로 둘 수 없습니다.",message: "", preferredStyle: UIAlertController.Style.alert)
            
            let cancelButton = UIAlertAction(title : "확인", style: UIAlertAction.Style.cancel, handler : nil)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func okActions() {
        performSegue(withIdentifier: "GotoSetting", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentURL.text = webURL
    }
}
