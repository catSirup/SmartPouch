//
//  MyBeacon.swift
//  SmartPouch
//
//  Created by YoungwooCNI on 2018. 10. 11..
//  Copyright © 2018년 Youngwoo. All rights reserved.
//

import Foundation
import CoreLocation

// 비콘 정보
class MyBeacon
{
    var uuid : String
    var major : String
    var minor : String
    
    init (UUID _uuid : String, Major _major : String, Minor _minor : String)
    {
        uuid = _uuid
        major = _major
        minor = _minor
    }
}
// 연락처
class MyAddress
{
    var emailAddress : String
    var phoneNumber : String
    
    init (EmailAddress _emailAddress : String, PhoneNumber _phoneNumber : String)
    {
        emailAddress = _emailAddress
        phoneNumber = _phoneNumber
    }
}

var myBeacon = MyBeacon(UUID: "", Major: "", Minor: "")         // 저장된 내 비콘의 정보가 담길 인스턴스
var myAddress = MyAddress(EmailAddress: "", PhoneNumber: "")    // 저장된 내 연락처가 담길 인스턴스
var isFound : Bool = true                           // 포어그라운드에서
                                                    // true  - 잃어버렸을 때의 alret창
                                                    // false - 찾았을 때의 alret창

var isLostAlert : Bool? = nil                       // 백그라운드에서 푸시알림을 눌렀을 때
                                                    // true  - 잃어버렸을 때의 alret창
                                                    // false - 찾았을 때의 alret창

var webURL : String = "https://catsirup.github.io"  // 광고페이지에 들어갈 URL

var isDetecting : Bool = false                      // 비콘 탐지를 하고 있는지 아닌지 확인
var isBackground : Bool = false                     // 현재 백그라운드 상태인지 아닌지 확인
let homeInstance : Home = Home.sharedInstance       // 홈화면 인스턴스
