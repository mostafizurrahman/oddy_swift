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
    let columnCount = 6
    var rowCount = 0

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
        debugPrint("t0a")
        self.letterLabel.text = self.sourceLetter[3]
        self.animationBar.configureGradient()
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
//        self.view.layoutIfNeeded()
        
        
//        for _hexagon in self.hexagonButtons {
//            _hexagon.setNeedsDisplay()
//            _hexagon.setLayers(hasLabelAnimation: false)
//        }
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
