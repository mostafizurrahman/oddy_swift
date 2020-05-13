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
    let columnCount = 8
    var rowCount = 0
    var shouldConfigure = true

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
            self.shouldConfigure = false
            self.letterLabel.text = self.sourceLetter[3]
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
                                           source: self.sourceLetter[3])
            self.view.layoutIfNeeded()
            self.animationBar.startAnimation(withDuration: 30)
        }
    }
    
    fileprivate func checkGameStatus(){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        if self.letterContainer.isGameOver {
//            debugPrint("SES! GAME OVER!!!!")
//        } else {
//            debugPrint("choluk! GAME ON!")
//        }
        
        self.letterContainer.isGameOver = true
        if let _touch = touches.first {
            let _locatoin = _touch.location(in: self.letterContainer)
            for _view in self.letterContainer.subviews {
                if _view.frame.contains(_locatoin){
                    if let _label = _view.subviews.first as? UILabel {
                        if _label.text == self.sourceLetter[3] {
                            self.letterContainer.isGameOver = false
                            self.letterContainer.generateIndices()
                            self.letterContainer.generateViews()
                            
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
