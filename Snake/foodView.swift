//
//  foodView.swift
//  Snake
//
//  Created by zhn on 16/11/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class foodView: UIView {
    
    //================================================================================
    // MARK:- 属性
    //================================================================================
    var foodHeight = itemWH
    var foodWidth = itemWH
    var foodCenterX = 0
    var foodCenterY = 0
    var snakeBodyArray = [CGRect]()
    fileprivate let padding:CGFloat = 16
    
    //================================================================================
    // MARK:- life cycle
    //================================================================================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        randomPosition()
    }
    
    //================================================================================
    // MARK:- public methods
    //================================================================================
    func randomPosition(){
        // 新出现的食物不能再蛇身所在位置
        while true {
            var needBreak = true
            foodCenterX = foodView.randomNum(num: Int(screenWidth - padding)) + Int(padding/2)
            foodCenterY = foodView.randomNum(num: Int(screenHeight - padding)) + Int(padding/2)
            let currentRect = CGRect(x:foodCenterX - (Int(itemWH))/2, y: foodCenterY - (Int(itemWH))/2, width: Int(foodWidth), height: Int(foodHeight))
            for rect in snakeBodyArray{
                if rect.intersects(currentRect){
                    needBreak = false
                    break
                }
            }
            if needBreak {
                break
            }
        }
       
        self.center = CGPoint(x: foodCenterX, y: foodCenterY)
        self.bounds = CGRect(x: 0, y: 0, width: foodWidth, height: foodHeight)
    }
    
    class func randomNum(num: Int) -> Int {
        return Int(arc4random_uniform(UInt32(num)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
