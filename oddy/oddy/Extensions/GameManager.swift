//
//  GameManager.swift
//  oddy
//
//  Created by Mostafizur Rahman on 15/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit
import StoreKit

class GameManager: NSObject {
    
    var toughChar:String = ""
    
    var coinCounter = 0 {
        didSet{
            let _addCoin = self.gameTitle.lowercased().elementsEqual("odd color")
                ? self.getColorCoin() : self.getCointCount()
            let _coins = UserDefaults.standard.integer(forKey: "coins") + _addCoin
            DispatchQueue.global().async {
                FirebaseManager.shared.updateGame(conins: _coins)
            }
        }
    }
    var writeAnserCount = 0
    var timeCounter:Double = 0
    var isHardGame = false
    var gameTitle = ""
    var isOddColor:Bool {
        get {
            return self.gameTitle.lowercased().elementsEqual("odd color") ||
            self.gameTitle.lowercased().elementsEqual("color blind")
        }
    }
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
    
    func colorBlindResult() -> String {
        if self.writeAnserCount > 28 {
            return "no color blindness"
        } else {
            return "you may have color disorder"
        }
    }
    
    func getEyeIcon()->String?{
        if self.gameTitle.lowercased().elementsEqual("color blind"){
            if self.writeAnserCount > 30 {
                return "eye"
            }
            return "eye1"
        }
        return nil
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
    
    
    func setColorTimer(){
        if self.writeAnserCount < 2 {
            self.timeCounter = 31
        } else if self.writeAnserCount < 20 {
            self.timeCounter = 26
        } else if self.writeAnserCount < 40 {
            self.timeCounter = 21
        } else {
            self.timeCounter = 16
        }
    }
    
    func getBestResult() -> Int {
        if self.gameTitle.lowercased() == "odd letter" {
            return UserDefaults.standard.integer(forKey: "odd_letter_best_score")
        } else if self.gameTitle.lowercased() == "odd color" {
            return UserDefaults.standard.integer(forKey: "odd_color_best_score")
        }
        return 0
    }
    
    func setBest(score:Int){
        if self.gameTitle.lowercased() == "odd letter" {
            let _score = UserDefaults.standard.integer(forKey: "odd_letter_best_score")
            if _score < score {
                UserDefaults.standard.set(score, forKey: "odd_letter_best_score")
            }
        } else if self.gameTitle.lowercased() == "odd color" {
            let _score = UserDefaults.standard.integer(forKey: "odd_color_best_score")
            if _score < score {
                UserDefaults.standard.set(score, forKey: "odd_color_best_score")
            }
        }
    }
    
    func getCointCount( )->Int{
        switch Int(self.timeCounter-1) {
        case 25,30,20:
            return 0
        case 15 :
             return 3
        case 10 :
            return 5
        default:
            return 5
        }
    }
    
    func getColorCoin( )->Int{
        switch Int(self.timeCounter-1) {
        case 30,25:
            return 1
        case 20 :
             return 5
        default:
            return 10
        }
    }
    
    func getAnimalName()->String {
        let _unit = Int(58.0 / 5.0)
      
        if self.writeAnserCount > _unit * 4 {
            return "Hawk"
        } else if self.writeAnserCount > _unit * 3 {
            return "Cheetah"
        } else if self.writeAnserCount > _unit * 2 {
            return "Cat"
        } else if self.writeAnserCount > _unit  {
            return "Fox"
        } else {
            return "Rat"
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
    
    fileprivate func _getDifference()->Double{
        
        if self.writeAnserCount < EyePerformance.poor.rawValue {
            return  15
        }else if self.writeAnserCount < EyePerformance.average.rawValue {
            return  13
        } else if  self.writeAnserCount < EyePerformance.good.rawValue {
            return  10
        } else if self.writeAnserCount < 50 {
            return  7
        } else if self.writeAnserCount < EyePerformance.best.rawValue {
            return 5
        } else {
            return 4
        }
    }
    
    func createColors()->(UIColor, UIColor){
        let _sourceColor = UIColor.init(random:true)
        let _diffColor = UIColor.init(baseColor:_sourceColor,
                                      difference:self._getDifference())
        return (_sourceColor, _diffColor)
    }
    
    
    
    func requestReview(){
        
            if #available(iOS 10.3, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    SKStoreReviewController.requestReview()
                }
            }
    }
}
