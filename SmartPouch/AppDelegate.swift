//
//  AppDelegate.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 1..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 10 이상에서 사용하는 노티관련 기능
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //creating the notification content
        isBackground = true
        isLostAlert = nil
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        isBackground = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.s
    }
      
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        if (isLostAlert == true) {
            let alertController = UIAlertController(title: "스마트 파우치와\n연결이 끊어졌습니다.", message: "파우치를 확인하세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
                let webPage = UIApplication.topViewController()?.storyboard?.instantiateViewController(withIdentifier: "WebPageView")
                UIApplication.topViewController()?.present(webPage!, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            
            
        } else if (isLostAlert == false) {
            let alertController = UIAlertController(title: "스마트 파우치와\n연결되었습니다.", message: "파우치를 꼭 챙기세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
                let webPage = UIApplication.topViewController()?.storyboard?.instantiateViewController(withIdentifier: "WebPageView")
                UIApplication.topViewController()?.present(webPage!, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
}

// 최상위 뷰 가져오기 위해 구현함.
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

