//
//  Alert.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 30/10/2018.
//  Copyright © 2018 Youngwoo. All rights reserved.
//

import UIKit

class Alert {
    static func showAlert(_ title: String, _ message: String) {
        print("알럿")
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler:  {(action: UIAlertAction) -> Void in
            self.okActions()
            }
        ))
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.shared.keyWindow?.rootViewController?.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
    
    static func okActions() {
        homeInstance.gotoWebPage()
    }
}
