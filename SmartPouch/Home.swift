//
//  Home.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 11..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

// 백그라운드에서 로컬 알림 눌렀을 때, 상황에 맞게 알림창 띄울 수 있도록 함.


import UIKit
import CoreLocation
import UserNotifications
import AVFoundation

extension Home {
    func setLocalNotificaion(_ Title : String, _ Body : String, _ isLost : Bool) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.categoryIdentifier = "연결 관련"
                content.title = Title
                content.body = Body
                if (isLost == true) {
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "smartpouchalert.wav"))
                }
                else {
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "smartpouchfind.wav"))
                }
                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                let request = UNNotificationRequest(identifier: "beaconAlert", content: content, trigger: nil)
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error) in
                    print(error?.localizedDescription ?? "")
                }
            }
        }
        
    }
}

class Home: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var announcetext: UILabel!
    @IBOutlet weak var findSmartPouchText: UILabel!
    @IBOutlet weak var beaconInfo: UILabel!
    @IBOutlet weak var findSwitch: UISwitch!
    @IBOutlet weak var addressInfo: UILabel!
    var locationManager : CLLocationManager!
    var player : AVAudioPlayer?
    
    @IBOutlet var beaconState: UILabel!
    var count : Int = 0;
    
    let beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: myBeacon.uuid)!, major: CLBeaconMajorValue(myBeacon.major)!, minor: CLBeaconMinorValue(myBeacon.minor)!, identifier: "Youngwoo")
    static let sharedInstance = Home()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI Text  세팅
        if (myBeacon.uuid == "") {
            announcetext.text = "현재 등록된 스마트 파우치가 없습니다."
            findSmartPouchText.text = "스마트 파우치 등록 필요"
            
            beaconInfo.text = "등록된 스마트 파우치가 없습니다."
            findSwitch.isHidden = true;
            
            addressInfo.text = "등록된 연락처가 없습니다."
        } else {
            announcetext.text = "현재 등록된 스마트 파우치가 있습니다."
            findSmartPouchText.text = "스마트 파우치 탐색 시작"
            
            beaconInfo.text = "UUID : \(myBeacon.uuid)\nMajor : \(myBeacon.major)\nMinor : \(myBeacon.minor)"
            findSwitch.isHidden = false;
            
            addressInfo.text = "Phone Number : \(myAddress.phoneNumber)\nEmail Address : \(myAddress.emailAddress)"
        }
        
        if (isDetecting == false)
        {
            // 스위치
            findSwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
            detectBeaconOn()
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // 모니터링 종료해주는 함수
    func stopScanningForBeaconRegion(beaconRegion: CLBeaconRegion) {
        locationManager.stopMonitoring(for: beaconRegion)
    }
    
    // 위치 서비스에 대한 권한이 받아들여지면 MonitorBeacons() 함수 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            monitorBeacons()
        }
    }
    
    // Monitoring 진행이 가능한 상태면 Monitoring 진행
    func monitorBeacons(){
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            // 디바이스가 이미 영역 안에 있거나 앱이 실행되고 있지 않은 상황에서도 영역 내부 안에 들어오면 백그라운드에서 앱을 실행시켜
            // 헤당 노티피케이션을 받을 수 있게 함
            beaconRegion.notifyEntryStateOnDisplay = true
            // 영역 안에 들어온 순간이나 나간 순간에 해당 노티피케이션을 받을 수 있게 함
            beaconRegion.notifyOnExit = true
            beaconRegion.notifyOnEntry = true
            locationManager.startMonitoring(for: beaconRegion)
        }else{
            print("CLLocation Monitoring is unavailable")
        }
    }
    
    // 모니터링이 실행된 후 영역의 판단이 이루어지는 순간에 이 메소드가 실행
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {        // 영역 안에 들어온 순간
            locationManager.startRangingBeacons(in: beaconRegion)
        }else if state == .outside { // 영역 밖에 나간 순간
            locationManager.stopRangingBeacons(in: beaconRegion)
        }else if state == .unknown {
            print("Now unknown of Region")
        }
    }
    
    //func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    //    print("비콘이 범위 내에 있음")
    //    playSound("smartpouchfind.wav")
    //    BeaconAlertPopup(Title: "스마트 파우치와 연결되었습니다.", Msg: "파우치를 꼭 챙기세요")
    //}
    
    //func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    //    print("비콘이 범위 밖을 벗어남")
    //    BeaconAlertPopup(Title: "스마트 파우치와 연결이 끊어졌습니다.", Msg: "파우치를 확인하세요")
    //    playSound("smartpouchalert.wav")
    //}
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        count += 1
        print(String("\(count), isFound : \(isFound)"))
        if beacons.count > 0 {
            let nearestBeacon = beacons.first!
            switch nearestBeacon.proximity {
            case .immediate:
                //beaconState.text = String("\(count), immediate")
                break
            case .near:
                //beaconState.text = String("\(count), near")
                break
                
            case .far:
                //beaconState.text = String("\(count), far")
                break
                
            case .unknown:
                //beaconState.text = String("\(count), unknown")
                break
            }
            
            if (isFound == false)
            {
                if (isBackground == true)
                {
                    setLocalNotificaion("연결되었습니다.", "스마트 파우치와 다시 연결되었습니다.", false)
                    isLostAlert = false
                }
                else
                {
                    playSound("smartpouchfind.wav")
                    BeaconAlertPopup(Title: "스마트 파우치와 연결되었습니다.", Msg: "파우치를 꼭 챙기세요")
                }
                isFound = true
            }
        }
        else
        {
            if (isFound == true)
            {
                if (isBackground == true)
                {
                    setLocalNotificaion("연결이 해제되었습니다.", "스마트 파우치의 위치를 확인해주세요.", true)
                    isLostAlert = true
                }
                else
                {
                    BeaconAlertPopup(Title: "스마트 파우치와 연결이 끊어졌습니다.", Msg: "파우치를 확인하세요")
                    playSound("smartpouchalert.wav")
                }
                isFound = false;
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func switchStateDidChange(_ sender: UISwitch){
        if (sender.isOn == true) {
            isDetecting = true
            detectBeaconOn()
        } else {
            isDetecting = false
            locationManager.delegate = nil
            stopScanningForBeaconRegion(beaconRegion: beaconRegion)
        }
    }
    
    func detectBeaconOn() {
        // 위치 서비스 권한 요청 및 백그라운드 위치 갱신 코드
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        isDetecting = true
    }
    
    func playSound(_ soundName : String) {
        let path = Bundle.main.path(forResource: soundName, ofType : nil)!
        let url = URL(fileURLWithPath: path)
        
        do  {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print ("Error")
        }
    }

    // 비콘 잃어버렸을 때
    func BeaconAlertPopup(Title title : String, Msg msg : String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            self.okActions()
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gotoWebPage() {
        let webPage = self.storyboard?.instantiateViewController(withIdentifier: "WebPageView")
        self.present(webPage!, animated: true, completion: nil)
    }
    
    func okActions() {
        player?.stop()
        gotoWebPage()
    }
    @IBAction func GotoSetting(_ sender: Any) {
        let setting = self.storyboard?.instantiateViewController(withIdentifier: "Setting")
        self.present(setting!, animated: true, completion: nil)
    }
}
