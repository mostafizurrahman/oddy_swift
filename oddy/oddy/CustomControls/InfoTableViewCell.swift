//
//  InfoTableViewCell.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 6/8/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gredientBulletView: IAVGradientBullet!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var leadingLabelLayout: NSLayoutConstraint!
    @IBOutlet weak var leaadingImageLayout: NSLayoutConstraint!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
