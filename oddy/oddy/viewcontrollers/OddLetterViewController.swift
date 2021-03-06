//
//  OddLetterViewController.swift
//  oddy
//
//  Created by Mostafizur Rahman on 10/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit
import StoreKit

protocol GameEndDelegate:NSObjectProtocol{
    func dismissSelf(isPlayAgain:Bool)
}

class OddLetterViewController: UIViewController {
    typealias FM = FirebaseManager
    var sourceLetter:[String] = []
    var letterArray:[String] = []
    let columnCount = 8//GameManager.shared.isHardGame ? 10 : 8
    var rowCount = 0
    var shouldConfigure = true
    let gm = GameManager.shared

    @IBOutlet weak var animationBar:CardAnimationView!
    @IBOutlet weak var winButton:IARadialButton!
    @IBOutlet weak var coinButton:IARadialButton!
    @IBOutlet weak var letterLabel:UILabel!
    @IBOutlet weak var letterContainer:LetterGameView!
    
    @IBOutlet var spaceLayout:[NSLayoutConstraint]!
    
    var gameCount = 1
    
//    @IBOutlet var hexagonButtons: [HexagoanView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gm.gameTitle = "Odd Letter"
        self.gm.writeAnserCount = 0
        self.gm.coinCounter = 0
        self.gm.timeCounter = 0
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.shouldConfigure {
            
            guard let _source = self.sourceLetter.last else {return}
            self.shouldConfigure = false
            self.letterLabel.text = _source
            self.animationBar.configureGradient(delegate: self)
            let _cellWidth = self.letterContainer.frame.width / CGFloat(self.columnCount)
            self.rowCount = Int(self.letterContainer.frame.height / _cellWidth)
            let extra = self.letterContainer.bounds.height - CGFloat(self.rowCount) * _cellWidth
            for _layout in self.spaceLayout {
                _layout.constant += extra / 2
            }
            self.letterContainer.configure(withData: self.letterArray,
                                           row: self.rowCount,
                                           column: self.columnCount,
                                           dimension:_cellWidth,
                                           source: self.sourceLetter)
            self.view.layoutIfNeeded()
            self.animationBar.startAnimation(withDuration: 30)
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        super.touchesBegan(touches, with: event)
        if self.letterContainer.isGameOver {
            self.gm.requestReview()
        }
        guard let _source = self.sourceLetter.last else {return}
        var isGameOver = true
        if let _touch = touches.first {
            let _locatoin = _touch.location(in: self.letterContainer)
            let _boardLocation = _touch.location(in: self.letterContainer)
            if self.letterContainer.frame.contains(_boardLocation) &&
            !self.letterContainer.isGameOver{
                for _view in self.letterContainer.subviews {
                    if _view.frame.contains(_locatoin){
                        if let _label = _view.subviews.first as? UILabel {
                            if _label.text == _source {
                                isGameOver = false
                                self.updateGamerResult()
                                self.gm.setTimerCounter()
                                self.animationBar.startAnimation(withDuration: gm.timeCounter)
                                self.letterContainer.configureGame()
                            }
                        }
                        break
                    }
                }
            } 
        }
        if isGameOver {
            self.gameCount += 1
            self.onAnimationCompleted()
            self.animationBar.removeAnimations()
            self.gm.setBest(score: self.gm.writeAnserCount)
        }
        self.letterContainer.isGameOver = isGameOver
        if isGameOver && self.gameCount % 3 == 0 {
            
            self.gm.requestReview()
            
        }
        
        if isGameOver && self.gameCount % 4 == 0 {
            if let _root = self.navigationController?
                .viewControllers.first as? HomeViewController {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.70) {
                    _root.showAd()
                }
            }
        }
    }
    
    
    
    @IBAction func exitGame(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.animationBar.createAnimationGroup()
    }
    
    var skipCount = 0
    
    
    @IBAction func nextCombination(_ sender:IARadialButton){
        if self.letterContainer.isGameOver {
            self.onAnimationCompleted()
        }
        else if self.skipCount < 3 {
            self.skipCount += 1
            self.gm.setTimerCounter()
            self.letterContainer.configureGame()
            self.animationBar.startAnimation(withDuration: gm.timeCounter)
        }
    }
    
    
    @IBAction func openCoins(_ sender:IARadialButton){
        
    }
    
    
    @IBAction func openWins(_ sender:IARadialButton){
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func updateGamerResult(){
        self.gm.writeAnserCount += 1
        self.winButton.setTitle("\(self.gm.writeAnserCount)", for: UIControl.State.normal)
        GameManager.shared.coinCounter += self.gm.getCointCount()
        self.coinButton.setTitle("\(self.gm.coinCounter)", for: UIControl.State.normal)
    }
    
    override func dismissSelf(isPlayAgain:Bool) {
        debugPrint("done!")
        if isPlayAgain {
            self.playAgain()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func playAgain(){
        self.letterContainer.isGameOver = false
        self.gm.writeAnserCount = 0
        self.gm.coinCounter = 0
        self.gm.timeCounter = 0
        self.winButton.setTitle("\(self.gm.writeAnserCount)", for: UIControl.State.normal)
        self.coinButton.setTitle("\(self.gm.coinCounter)", for: UIControl.State.normal)
        self.animationBar.startAnimation(withDuration: 31)
        self.letterContainer.configureGame()
        self.gameCount += 1
    }
    
}


