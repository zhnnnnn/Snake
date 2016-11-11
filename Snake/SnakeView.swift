//
//  SnakeView.swift
//  Snake
//
//  Created by zhn on 16/11/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import CoreGraphics

class SnakeView: UIView {

    var bodyCenterArray: [CGRect] = [CGRect]()
    var snakeHead = CGRect()
    
    //================================================================================
    // MARK:- life cycle
    //================================================================================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.randomRectArray()
    }
    
    //================================================================================
    // MARK:- public method
    //================================================================================
    func randomRectArray() {
        
        bodyCenterArray.removeAll()
        
        let x = foodView.randomNum(num: Int(screenWidth/2)) + Int(screenWidth/4)
        let y = foodView.randomNum(num: Int(screenHeight/2)) + Int(screenHeight/4)
        
        for i in 0...2 {
            let rect = CGRect(x: x - (Int(itemDelta) * i), y: y, width: Int(itemWH), height: Int(itemWH))
            bodyCenterArray.append(rect)
        }
        
        if let tempRect = bodyCenterArray.first {
            snakeHead = tempRect
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        for value in bodyCenterArray{
            context?.addRect(value)
        }
        context?.fillPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
