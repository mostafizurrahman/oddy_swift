//
//  FirebaseManager.swift
//  oddy
//
//  Created by Mostafizur Rahman on 5/6/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

import Firebase

class FirebaseManager: NSObject {
    typealias FM = FirebaseManager
    static let G_COLOR = "odd_color"
    static let G_LETER = "odd_letter"
    static let G_BLIND = "clor_blind"
    static let shared = FirebaseManager()
    var firebaseRef:DatabaseReference?
    var adRunning = false
    var subscriptionRunning = true
    var oddLetterCount = 0
    var oddColorCount = 0
    var colorBlindCount = 0
    
    override init() {
        super.init()
        self.subscriptionRunning = UserDefaults.standard.bool(forKey: "subscribed")
        self.getFireData()
        if self.subscriptionRunning {
            
        }
    }
    
    fileprivate func getFireData(){
        firebaseRef = Database.database().reference()
        firebaseRef?.child("oddy").child("configure").observe(DataEventType.value, with: { (_snapData) in
            let fireData = _snapData.value as? [String : AnyObject] ?? [:]
            self.adRunning = fireData["fbad"] as? Bool ?? false
            self.subscriptionRunning = fireData["subscription"] as? Bool ?? true
            if !self.subscriptionRunning {
                SubscriptionManager.shared.isSubscribed = true
            }
        })
    }
    
    func updateGame(conins:Int){
        guard let _deviceID = UIDevice.current.identifierForVendor else {
            return
        }
        let _deviceChild = firebaseRef?
            .child("oddy")
            .child("devices")
            .child(_deviceID.uuidString)
        
       _deviceChild?.observe(DataEventType.value, with: { (_snapData) in
            if _snapData.exists() {
                let fireData = _snapData.value as? [String : AnyObject] ?? [:]
                let _coins = fireData["coins"] as? Int ?? 0
                let _coinCount = _coins > conins ? _coins : conins
                _deviceChild?.child("coins").setValue(_coinCount)
            } else {
                let _parent = self.firebaseRef?
                .child("oddy")
                .child("devices")
                .child(_deviceID.uuidString)
                _parent?.child("coins")
                .setValue(conins)
                _parent?.child(FM.G_LETER).setValue(4)
                _parent?.child(FM.G_COLOR).setValue(4)
                _parent?.child(FM.G_BLIND).setValue(4)
            }
        })
    }
    
    func updateCount(){
        guard let _deviceID = UIDevice.current.identifierForVendor else {
            return
        }
        let _deviceChild = firebaseRef?
            .child("oddy")
            .child("devices")
            .child(_deviceID.uuidString)
        _deviceChild?.observe(DataEventType.value, with: { (_snapData) in
            if _snapData.exists() {
                let fireData = _snapData.value as? [String : AnyObject] ?? [:]
                self.oddColorCount = fireData[FM.G_COLOR] as? Int ?? 0
                self.colorBlindCount = fireData[FM.G_BLIND] as? Int ?? 0
                self.oddLetterCount = fireData[FM.G_LETER] as? Int ?? 0
            }
        })
    }

    func update(gameName game:String, count:Int){
        guard let _deviceID = UIDevice.current.identifierForVendor else {
            return
        }
        if count >= 0 {
            self.firebaseRef?
            .child("oddy")
            .child("devices")
            .child(_deviceID.uuidString)
            .child(game)
            .setValue(count)
        }
    }
}
