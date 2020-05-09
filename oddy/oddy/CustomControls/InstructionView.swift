//
//  IstructionView.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 7/5/20.
//  Copyright © 2020 image-app. All rights reserved.
//

import UIKit

protocol SelectionDelegate : NSObjectProtocol {
    
    func onDoneTap(shouldPlay:Bool)
}

class InstructionView: UIView {
    
    var contentView: UIView!
    @IBOutlet var sampleLables: [UILabel]!
    @IBOutlet weak var switching: UISwitch!
    @IBOutlet weak var instructionLabel: UILabel!
    weak var instructionDelegate:SelectionDelegate?
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var doneButton: IALinearButton!
    
    @IBAction func hideForever(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "never_ask")
    }
    
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
        
        self.instructionDelegate?.onDoneTap(shouldPlay: false)
        
    }
    @IBAction func startPlaying(_ sender: Any) {
        self.instructionDelegate?.onDoneTap(shouldPlay:true)
    }
    
   //MARK:
   func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
       
        self.layoutIfNeeded()
   }
    
    func setShadows(){
           
//           self.doneButton.layer.shadowColor = UIColor.white.cgColor
//           self.doneButton.layer.shadowRadius = 12
//           self.doneButton.layer.shadowOpacity = 1.2
           self.switching.layer.shadowColor = UIColor.white.cgColor
           self.switching.layer.shadowRadius = 12
           self.switching.layer.shadowOpacity = 0.76
       }
}

