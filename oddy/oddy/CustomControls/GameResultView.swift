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
     @IBOutlet var congratsLabel: UILabel!
     weak var resultDelegate:GameEndDelegate?
    
     
     
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

            self.resultDelegate?.dismissSelf()
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
