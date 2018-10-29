//
//  Setting.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 11..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

import UIKit

extension Setting : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.text = menuArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            // 새 파우치 설정
            let alertController = UIAlertController(title: "새 스마트 파우치로 변경하시겠습니까?",message: "변경하시려면 확인 버튼을 눌러주세요.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.destructive) { (action: UIAlertAction) -> Void in
                self.okActions_ChangePouch()
            }
            let cancelButton = UIAlertAction(title : "취소", style: UIAlertAction.Style.cancel, handler : nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 1) {
            // 연락처 재 설정
            let alertController = UIAlertController(title: "분실 시 연락할 주소를 변경하시겠습니까?",message: "변경하시려면 확인 버튼을 눌러주세요.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.destructive) { (action: UIAlertAction) -> Void in
                self.okActions_ChangeAddress()
            }
            let cancelButton = UIAlertAction(title : "취소", style: UIAlertAction.Style.cancel, handler : nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 2) {
            // 웹페이지 주소 변경
            let setWebURL = self.storyboard?.instantiateViewController(withIdentifier: "SetWebUrl")
            self.present(setWebURL!, animated: true, completion: nil)
        } else if (indexPath.row == 4) {
            // 비콘 거리 탐지
        }
    }
}

extension Setting : UITableViewDelegate {
    
}

extension Setting {
    func okActions_ChangePouch() {
        performSegue(withIdentifier: "ChangeBeacon", sender: nil)
    }
    func okActions_ChangeAddress() {
        myAddress.emailAddress = ""
        myAddress.phoneNumber = ""
        performSegue(withIdentifier: "ChangeAddress", sender: nil)
    }
}

class Setting: UIViewController {
    var menuArray : [String] = ["새 파우치 설정", "연락처 재 설정", "웹페이지 주소 변경", "비콘 탐지 거리 변경"]
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.dataSource = self;
        menuTableView.delegate = self;
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Custom Cell")
    }
    @IBAction func onClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
