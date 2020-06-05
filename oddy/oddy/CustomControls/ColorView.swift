//
//  ColorView.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 6/8/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit

class ColorView: UIView {

    @IBOutlet weak var testColorView: UIImageView!
//    @IBOutlet weak var colorDescriptionTextView: UITextView!
//    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet var colorContentView: UIView!
//    @IBOutlet weak var colorViewTitleLabel: UILabel!
    private(set) var correctIndex:Int = 0
    private(set) var sampleAnswerArray:[String] = [String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureXib()
    }
    func configureXib(){
        Bundle.main.loadNibNamed("ColorView", owner: self, options: nil)
        
        
        self.addSubview(self.colorContentView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func showInfoView(_ sender: Any) {
        
    }
    
    @IBAction func hideColorView(_ sender: Any) {
        
    }
    
    public func setData(data:[String:AnyObject], dimension:CGFloat){
        guard let imageName = data["data_image_name"] as? String else {
            return
        }
        self.testColorView.image = UIImage.init(named: imageName)
        if let indexStr = data["right_answer_index"] as? String {
            correctIndex = Int(indexStr)!
        }
        if let sampleAnswer = data["possible_values"] as? [String]{
            sampleAnswerArray = sampleAnswer
        }
        self.colorContentView.frame = CGRect(origin: .zero, size: CGSize(width: dimension, height: dimension));
        self.setNeedsLayout();
        self.setNeedsDisplay()
        self.colorContentView.setNeedsLayout()
        self.colorContentView.setNeedsDisplay()
        debugPrint("done")
    }
}
