//
//  NumberView.swift
//  Puzzle Eye Vision Power Test
//
//  Created by Mostafizur Rahman on 6/7/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit
protocol AnswerSelectionDelegate: NSObjectProtocol {
    func didSelectAnswer(isRight:Bool)
}
class NumberView: UIView {
    
    @IBOutlet var answerButtons: [IARadialButton]!
    @IBOutlet var numberPadView: UIView!
    weak var answerDelegate:AnswerSelectionDelegate?
    fileprivate var rightAnswer:String = ""
    fileprivate var imageName:String = ""
    fileprivate var testId:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureXib()
    }
    func configureXib(){
        Bundle.main.loadNibNamed("NumberView", owner: self, options: nil)
        self.numberPadView.frame = self.bounds;
        self.addSubview(self.numberPadView)
//        var changeTop = false
        let spacing:CGFloat = 7.5
//        if IAViewAnimation.SCREEN_WIDTH == 320 {
//            changeTop = true
//        } else if ConstantData.IPHONE_X {
//            changeTop = true
//            let scrnHeight = ConstantData.MAINSCRN_HEIGHT - 88
//            let selfHeight = (scrnHeight - ConstantData.MAINSCRN_WIDTH) / 2.0
//            spacing = selfHeight / 2.0 - 25
//        } else if ConstantData.MAINSCRN_WIDTH > 375 {
//            changeTop = true
//            let scrnHeight = ConstantData.MAINSCRN_HEIGHT
//            let selfHeight = (scrnHeight - ConstantData.MAINSCRN_WIDTH) / 2.0
//            spacing = selfHeight / 2.0 - 50.5
//
//        }
//        if changeTop {
            for constraint in self.numberPadView.constraints{
                if let identifier = constraint.identifier{
                    if identifier.elementsEqual("TOP") {
                        constraint.constant = spacing
                    }
                }
//            }
            self.setNeedsLayout()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
    }
 
    @IBAction func buttonPreeser(_ sender: IARadialButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        self.answerDelegate?.didSelectAnswer(isRight: title.lowercased().elementsEqual(rightAnswer))
    }
    
    func setAnsers(data answers:[String], rightAnswer answer:String){
        self.rightAnswer = answer
        let anserArray = answers.shuffle
        for (e1, e2) in zip(anserArray, self.answerButtons){
            e2.setTitle(e1, for: .normal)
           
        }
    }
}
