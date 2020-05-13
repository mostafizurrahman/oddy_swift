//
//  LetterGameView.swift
//  oddy
//
//  Created by Mostafizur Rahman on 13/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class LetterGameView: UIView {
    
    
    var letterArray:[String] = []
    var indexArray:[Int] = []
    var data:String = ""
    var _row = 0
    var _col = 0
    var _index = 0
    var _cellWidth:CGFloat = 0
    
    func configure(withData array:[String],
                   row:Int,
                   column:Int,
                   dimension:CGFloat,
                   source:String) {
        self.data = source
        self._row  = row
        self._col = column
        self._cellWidth = dimension
        self.letterArray = array
        self._index = array.firstIndex(where: { $0 == source}) ?? 0
        
        var r = Int.random(in: 0...self.letterArray.count-1)
        let _cellCount = row * column
        while _cellCount - 1 > self.indexArray.count {
            if r != self._index {
                self.indexArray.append(r)
            }
            r = Int.random(in: 1...self.letterArray.count - 1)
        }
        self.indexArray.append(self._index)
        self.indexArray = self.indexArray.shuffled()
        debugPrint(self.indexArray.count)
        
        let _size = CGSize(width: _cellWidth, height: _cellWidth)
        for i in 0...self._row-1 {
            for j in 0...self._col-1 {
                
                let _origin = CGPoint(x: CGFloat(j) * self._cellWidth,
                                      y: CGFloat(i) * self._cellWidth)
                let _frame = CGRect(origin: _origin, size: _size)
                let _cellView = UIView(frame: _frame)
                _cellView.layer.borderWidth = 0.25
                _cellView.layer.borderColor = UIColor.lightGray.cgColor
                _cellView.isUserInteractionEnabled = true
                let _label = UILabel(frame: CGRect(origin: .zero, size: _size))
                let indexing = i * (self._col) + j
                _label.text = self.letterArray[self.indexArray[indexing]]
                _label.textAlignment = NSTextAlignment.center
                _label.font = UIFont(name:"Copperplate-Bold", size: self._cellWidth * 0.65)
                _cellView.addSubview(_label)
//                _label.backgroundColor = UIColor.red
                self.addSubview(_cellView)
            }
        }
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
