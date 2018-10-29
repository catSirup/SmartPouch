//
//  ViewController.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 1..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
        {
            if myBeacon.uuid == ""
            {
                let findSamrtPouch = self.storyboard?.instantiateViewController(withIdentifier: "FindSmartPouch")
                //locationManager.delegate = nil
                self.present(findSamrtPouch!, animated: true, completion: nil)
                //self.navigationController?.pushViewController(findSamrtPouch, animated: true)
            }
            else
            {
                let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                //locationManager.delegate = nil
                self.present(home!, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

