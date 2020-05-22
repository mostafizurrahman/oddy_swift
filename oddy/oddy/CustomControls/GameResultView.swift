//
//  GameResultView.swift
//  oddy
//
//  Created by Mostafizur Rahman on 17/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class GameResultView: UIView {

    

     var contentView: UIView!

    @IBOutlet var ICONVIEW:UIImageView!
     @IBOutlet var coinLabel: UILabel!
     @IBOutlet var winsLabel: UILabel!
    
    @IBOutlet weak var eyeCardView: CardView!
    @IBOutlet weak var gameTitle: LTMorphingLabel!
    @IBOutlet weak var bestResultLabel: UILabel!
    weak var resultDelegate:GameEndDelegate?
    
    @IBOutlet weak var animalView: UIImageView!
    @IBOutlet weak var eyeStatusLabel: LTMorphingLabel!
    
     var nibName: String {
         return String(describing: type(of: self))
     }
     
     override init(frame: CGRect) {
        super.init(frame: frame)

        loadViewFromNib()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadViewFromNib()
    }
     
     @IBAction func skipPlaying(_ sender: Any) {
        IAViewAnimation.animate(view: self, shouldVisible: false) { _finished in

            self.resultDelegate?.dismissSelf(isPlayAgain: false)
        }
         
     }
    
    @IBAction func dismiss(_ sender: Any) {
        IAViewAnimation.animate(view: self, shouldVisible: false) { (_finished) in
            
        }
        
    }
    
    @IBAction func playAgain(_ sender: Any) {
       IAViewAnimation.animate(view: self, shouldVisible: false) { _finished in

           self.resultDelegate?.dismissSelf(isPlayAgain: true)
       }
        
    }
    
    //MARK:
    func loadViewFromNib() {
         contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
         contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         contentView.frame = bounds
//        self.ICONVIEW.layer.cornerRadius = 24
//        self.ICONVIEW.layer.masksToBounds = true
         addSubview(contentView)
        
         self.layoutIfNeeded()
    }
}
