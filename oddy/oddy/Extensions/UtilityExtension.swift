//
//  UtilityExtension.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit
enum AnswerType {
    case wrong
    case right
    case timeout
    case unknown
}

enum EyePerformance:Int {
    case poor = 20
    case average = 35
    case good = 45
    case best = 55
    
}
class UtilityExtension: NSObject {

}
extension UIViewController {

    func topViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.navigationController {
            if let topViewController = navigation.viewControllers.last {
                return topViewController
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topViewController()
            }
            return tab.topViewController()
        }
        return self.presentedViewController?.topViewController()
    }
}

extension UIApplication {
    
    func topViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topViewController()
    }
}
extension Int {
    static func random(in range: ClosedRange<Int>, excluding x: Int) -> Int {
        if range.contains(x) {
            let r = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            return r == x ? range.upperBound : r
        } else {
            return Int.random(in: range)
        }
    }
    
    static func urandArray(count: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < count {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
        }
        return Array(uniqueNumbers)
    }
}


extension UIViewController : AnimationDelegate {
    @objc func onAnimationCompleted() {
        debugPrint("game over")
        self.openGameOverDialog()
        
    }
    
    func onAnimationStarted() {
        
    }
    
    func onAnimationStoped() {
        
    }
    
    func openGameOverDialog(){
        
        let _resultView = GameResultView(frame: self.view.bounds)
        _resultView.eyeCardView.isHidden = !GameManager.shared.isOddColor
        _resultView.resultDelegate = self
        _resultView.isHidden = true
        _resultView.coinLabel.text = "\(GameManager.shared.coinCounter)"
        _resultView.winsLabel.text = "\(GameManager.shared.writeAnserCount)"
        _resultView.bestResultLabel.text = "\(GameManager.shared.getBestResult())"
        var animalName = ""
        if !_resultView.eyeCardView.isHidden {
            animalName = GameManager.shared.getAnimalName().lowercased()
            _resultView.animalView.image = UIImage(named:animalName)
            
        }
        IAViewAnimation.animate(view: _resultView, shouldVisible: true) { (_finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                _resultView.gameTitle.morphingEffect = LTMorphingEffect.evaporate
                _resultView.gameTitle.text = GameManager.shared.gameTitle
                _resultView.gameTitle.updateProgress(progress: 0.0)
                _resultView.gameTitle.start()
                if !_resultView.eyeCardView.isHidden {
                    _resultView.eyeStatusLabel.morphingEffect = LTMorphingEffect.evaporate
                    _resultView.eyeStatusLabel.text =
                        GameManager.shared.gameTitle.lowercased().elementsEqual("color blind") ?
                            "You have \(GameManager.shared.colorBlindResult())"
                        : "Eye Vision Similar to \(animalName)."
                    _resultView.eyeStatusLabel.updateProgress(progress: 0.0)
                    _resultView.eyeStatusLabel.start()
                    if let _iconName = GameManager.shared.getEyeIcon(){
                        _resultView.animalView.image = UIImage(named: _iconName)
                    }
                }
            }
        }
    }
}

extension UIViewController :GameEndDelegate{
    @objc func dismissSelf(isPlayAgain:Bool) {
//        self.navigationController?.popViewController(animated: true)
    }
}


extension CGRect {
    static func -(left:CGRect, right:CGFloat)->CGRect{
        return  CGRect (x: left.origin.x + right + 4,
                        y: left.origin.y + right + 4,
                        width: left.width - right * 2 - 8,
                        height: left.height - right * 2 - 8)
    }
    
    static func +(left:CGRect, right:CGFloat)->CGRect{
        return  CGRect (x: left.origin.x - right,
                        y: left.origin.y - right,
                        width: left.width + right * 2,
                        height: left.height + right  * 2)
    }
}
