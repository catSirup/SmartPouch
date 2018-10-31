//
//  FindSmartPouch.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 11..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class FindSmartPouch: UIViewController, CLLocationManagerDelegate {
    var locationManager : CLLocationManager!
    var distance : Double = 10.0
    @IBOutlet weak var currentBeacon: UILabel!
    
    var centralManager:CBCentralManager!

    @IBAction func OnClick(_ sender: Any) {
        if (myBeacon.uuid == "")
        {
            let alertController = UIAlertController(title: "스마트 파우치 등록을 건너뛰시겠습니까?",message: "건너뛰시려면 확인 버튼을 눌러주세요.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title : "확인", style: UIAlertAction.Style.destructive) { (action: UIAlertAction) -> Void in
                self.okActions()
            }
            let cancelButton = UIAlertAction(title : "취소", style: UIAlertAction.Style.cancel, handler : nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let addressSetting = self.storyboard?.instantiateViewController(withIdentifier: "AddressSetting")
            self.present(addressSetting!, animated: true, completion: nil)
        }
    }
    
    func okActions() {
        performSegue(withIdentifier: "Home", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iBeacon을 쓰기 위해 최적화 해줌.
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        
        myBeacon.uuid = ""
        myBeacon.major = ""
        myBeacon.minor = ""
        
        locationManager.requestAlwaysAuthorization()
        startScanningForBeaconRegion(beaconRegion: getBeaconRegion())
        
        centralManager = CBCentralManager()
        centralManager.delegate = self
    }
    
    func getBeaconRegion() -> CLBeaconRegion {
        /// ios는 uuid를 필수로 적어줘야 한다.
        let beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "C01A269D-D9B8-3B36-A2B2-CF99E719F573")!, identifier: "Youngwoo Beacon")
        return beaconRegion
    }
    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion) {
        //print(beaconRegion)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    // Delegate Methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons.first!
            // 일정 거리 내에 가장 가까운 스마트 파우치를 등록한다.
            if nearestBeacon.proximity == CLProximity.immediate {
                currentBeacon.text = "스마트 파우치 등록 완료"
                myBeacon.uuid = nearestBeacon.proximityUUID.uuidString
                myBeacon.major = nearestBeacon.major.stringValue
                myBeacon.minor = nearestBeacon.minor.stringValue
            }
            else if nearestBeacon.proximity != CLProximity.immediate && myBeacon.uuid == "" {
                currentBeacon.text = "스마트 파우치 검색 중"
            }
        }
        else {
            currentBeacon.numberOfLines = 2
            currentBeacon.text = "현재 스마트 파우치가\n주변에 없습니다."
        }
    }
}

extension FindSmartPouch: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            break
        case .poweredOff:
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .unknown:
            break
        default:
            break
        }
    }
}

