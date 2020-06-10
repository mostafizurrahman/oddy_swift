//
//  TestAnswer.swift
//  oddy
//
//  Created by Mostafizur Rahman on 24/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit


struct TestAnswer {
    let right:Bool
    let imageName:String
    let testId:String
    let isTimeout:Bool
    let answerDescription:String
    
    init(imageNamed imgName:String, testIds ids:String, rightAnswer isright:Bool) {
        right = isright
        imageName = imgName
        testId = ids
        if (isright){
            self.answerDescription = "Right answer was given!"
            
        } else {
            self.answerDescription = "Wrong answer was given!"
        }
        self.isTimeout = false
    }
    
    init(imageNamed imgName:String, testIds ids:String) {
        right = false
        imageName = imgName
        testId = ids
        self.answerDescription = "Time over!"
        self.isTimeout = true
    }
    
}
