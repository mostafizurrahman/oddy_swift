//
//  GameManager.swift
//  oddy
//
//  Created by Mostafizur Rahman on 15/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class GameManager: NSObject {
    
    var toughChar:String = ""
    var coinCounter = 0
    var writeAnserCount = 0
    var timeCounter:Double = 0
    var isHardGame = false
    
    static let shared = GameManager()
    override init() {
        super.init()
    }
    
    func getChar(fromArray letterArray:[String])->String {
        let index = Int.random(in: 0...letterArray.count-2)
        return letterArray[index]
    }
    
    func isSimilarChar() -> Bool {
        if self.writeAnserCount > 5 {
            return arc4random_uniform(2) == 0
        }
        return false
    }
    
    func setTimerCounter(){
        if self.writeAnserCount < 3{
            self.timeCounter = 31
        }
        else if self.writeAnserCount < 6{
            self.timeCounter = 26
        } else if self.writeAnserCount < 10 {
            self.timeCounter = 21
        }else if self.writeAnserCount < 17 {
            self.timeCounter = 16
        } else {
            self.timeCounter = 11
        }
    }
    
    func getCointCount( )->Int{
        switch Int(self.timeCounter-1) {
        case 25,30,20:
            return 5
        case 15 :
             return 10
        case 10 :
            return 15
        default:
            return 5
        }
    }
    
}
