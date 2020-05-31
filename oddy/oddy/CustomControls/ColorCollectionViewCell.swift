//
//  ColorCollectionViewCell.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 6/12/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: ColorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
