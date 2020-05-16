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
    var dataArray:[String] = []
    var data:String = ""
    var _row = 0
    var _col = 0
    var _index = 0
    var _cellWidth:CGFloat = 0
    var isGameOver = false
    
    let gm = GameManager.shared
    
    
    
    func configure(withData array:[String],
                   row:Int,
                   column:Int,
                   dimension:CGFloat,
                   source:[String]) {
        self.dataArray = source
        self.data = source.last ?? ""
        self._row  = row
        self._col = column
        self._cellWidth = dimension
        self.letterArray = array
        self._index = array.firstIndex(where: { $0 == self.data}) ?? 0
        self.configureGame()
    }
    
    func configureGame(){
        self.isGameOver = false
        let indices = self.generateIndices()
        self.generateViews(forIndices:indices)
    }
    
    
    fileprivate func generateIndices()->[Int]{
        var indexArray = [Int]()
        var r = Int.random(in: 0...self.letterArray.count-1)
        let _cellCount = self._row * self._col
        while _cellCount - 1 > indexArray.count {
            if r != self._index {
                indexArray.append(r)
            }
            r = Int.random(in: 1...self.letterArray.count - 1)
        }
        indexArray.append(self._index)
        indexArray = indexArray.shuffled()
        return indexArray
    }
    
    fileprivate func generateViews(forIndices indexArray:[Int]){
        for _view in self.subviews {
            IAViewAnimation.animate(view: _view, shouldVisible: false) { (_FINISHED) in
                _view.removeFromSuperview()
            }
        }
        let _size = CGSize(width: _cellWidth, height: _cellWidth)
        var isSimilar = self.gm.isSimilarChar()
        let similarData = self.dataArray.count > 2 ?
            self.gm.getChar(fromArray: self.dataArray) :
            self.gm.getChar(fromArray: self.letterArray)
        if similarData.elementsEqual(self.data) {
            isSimilar = false
        } else if let index = self.dataArray.firstIndex(of: similarData), isSimilar{
            self.dataArray.remove(at: index)
            debugPrint("removed ___ \(similarData)")
            
        }
        
        
        let dataIndex = Int.random(in: 0...self._row * self._col - 1)
        for i in 0...self._row-1 {
            for j in 0...self._col-1 {
                
                let _origin = CGPoint(x: CGFloat(j) * self._cellWidth,
                                      y: CGFloat(i) * self._cellWidth)
                let _frame = CGRect(origin: _origin, size: _size)
                let _cellView = UIView(frame: CGRect(origin: CGPoint(x: self.bounds.width,
                                                                     y: _origin.y),
                                                     size: _size))
                
                _cellView.layer.borderWidth = 0.25
                _cellView.layer.borderColor = UIColor.lightGray.cgColor
                _cellView.isUserInteractionEnabled = true
                let _label = UILabel(frame: CGRect(origin: .zero, size: _size))
                if isSimilar {
                    if dataIndex ==  i * (self._col) + j {
                        _label.text = self.data
                    } else {
                        _label.text = similarData
                    }
                } else {
                    let indexing = i * (self._col) + j
                    _label.text = self.letterArray[indexArray[indexing]]
                }
                _label.textAlignment = NSTextAlignment.center
                _label.font = UIFont(name:"System-Bold", size: self._cellWidth * 0.65)
                _cellView.addSubview(_label)
                self.addSubview(_cellView)
                UIView.animate(withDuration: 0.3) {
                    _cellView.frame = _frame
                }
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
