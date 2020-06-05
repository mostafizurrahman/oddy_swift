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
    
    static let shared = FirebaseManager()
    var adRunning = false
    var subscriptionRunning = true
    
    override init() {
        super.init()
        self.subscriptionRunning = UserDefaults.standard.bool(forKey: "subscribed")
    }
    
    

}
