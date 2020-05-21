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
    
    var coinCounter = 0 {
        didSet{
            let _coins = UserDefaults.standard.integer(forKey: "coins") + self.coinCounter
            UserDefaults.standard.set(_coins, forKey: "coins")
        }
    }
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
            return 0
        case 15 :
             return 5
        case 10 :
            return 10
        default:
            return 5
        }
    }
    
    func getBoxDimension()->Int{
        if self.writeAnserCount < 3 {
            return 2
        }
        if self.writeAnserCount < 8 {
            return 3
        }
        if self.writeAnserCount < 20 {
            return 4
        }
        if self.writeAnserCount < 40 {
            return 5
        }
        return 6
    }
    
    fileprivate func _getDifference()->CGFloat{
        let _difference:CGFloat = 255
        if self.writeAnserCount < EyePerformance.poor.rawValue {
            return _difference * 0.8
        }else if self.writeAnserCount < EyePerformance.average.rawValue {
            return _difference * 0.6
        }else if  self.writeAnserCount < EyePerformance.good.rawValue {
            return _difference * 0.4
        } else {
            return _difference * 0.2
        }
    }
    
    func createColors()->(UIColor, UIColor){
        let _sourceColor = UIColor.init(random:true)
        let _diffColor = UIColor.init(baseColor:_sourceColor,
                                      difference:self._getDifference())
        return (_sourceColor, _diffColor)
    }
    
}
