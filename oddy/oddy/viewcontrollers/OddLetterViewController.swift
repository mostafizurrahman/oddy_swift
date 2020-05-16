//
//  OddLetterViewController.swift
//  oddy
//
//  Created by Mostafizur Rahman on 10/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class OddLetterViewController: UIViewController {
    
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
    
//    @IBOutlet var hexagonButtons: [HexagoanView]!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let _source = self.sourceLetter.last else {return}
        self.letterContainer.isGameOver = true
        if let _touch = touches.first {
            let _locatoin = _touch.location(in: self.letterContainer)
            for _view in self.letterContainer.subviews {
                if _view.frame.contains(_locatoin){
                    if let _label = _view.subviews.first as? UILabel {
                        if _label.text == _source {
                            self.updateGamerResult()
                            self.gm.setTimerCounter()
                            self.letterContainer.configureGame()
                            self.animationBar.startAnimation(withDuration: gm.timeCounter)
                        }
                    }
                    break
                }
            }
        }
    }
    
    
    
    @IBAction func exitGame(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.animationBar.createAnimationGroup()
    }
    
    @IBAction func nextCombination(_ sender:IARadialButton){
        
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
    
}


extension OddLetterViewController : AnimationDelegate {
    func onAnimationCompleted() {
        debugPrint("game over")
    }
    
    func onAnimationStarted() {
        
    }
    
    func onAnimationStoped() {
        
    }
    
    
}
