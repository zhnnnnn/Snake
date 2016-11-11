//
//  ViewController.swift
//  Snake
//
//  Created by zhn on 16/11/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit


enum choseDirection {
    case left,right,up,down
}


class ViewController: UIViewController ,noticeViewDelegate{

    var currentTimer:Timer?
    var direction:choseDirection = choseDirection.down
    
    //================================================================================
    // MARK:- lazy load
    //================================================================================
    fileprivate lazy var snake: SnakeView = {
        let tempSnake = SnakeView()
        return tempSnake
    }()
    
    fileprivate lazy var food: foodView = {
        let tempFood = foodView()
        return tempFood
    }()
    
    lazy var notice : noticeView = {
        let tempNotice = noticeView()
        tempNotice.delegte = self
        return tempNotice
    }()
    //================================================================================
    // MARK:- life cycle
    //================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        view.addSubview(snake)
        snake.frame = view.bounds
        snake.addSubview(food)
        
        initGestures()
        
        gameStart()
    }
    
    //================================================================================
    // MARK:- pravite methods
    //================================================================================
    fileprivate func initGestures(){
        
        let swiperL = UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen(gesture:)))
        swiperL.direction = UISwipeGestureRecognizerDirection.left
        snake.addGestureRecognizer(swiperL)
        
        let swiperR = UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen(gesture:)))
        swiperR.direction = UISwipeGestureRecognizerDirection.right
        snake.addGestureRecognizer(swiperR)
        
        let swiperU = UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen(gesture:)))
        swiperU.direction = UISwipeGestureRecognizerDirection.up
        snake.addGestureRecognizer(swiperU)
        
        let swiperD = UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen(gesture:)))
        swiperD.direction = UISwipeGestureRecognizerDirection.down
        snake.addGestureRecognizer(swiperD)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressScreen(gesture:)))
        snake.addGestureRecognizer(longPress)
    }
    
    fileprivate func gameover(){
        currentTimer?.invalidate()
        currentTimer = nil
        notice.show(view,score: snake.bodyCenterArray.count)
    }
    
    fileprivate func gameStart(){
        
        snake.randomRectArray()
        food.snakeBodyArray = snake.bodyCenterArray
        food.randomPosition()
        direction = choseDirection.down
        
        startTimer(time: 0.2)
    }
    
    func startTimer(time:TimeInterval) {
        currentTimer?.invalidate()
        currentTimer = creteTimer(time: time)
        if let currentTimer = currentTimer {
            RunLoop.current.add(currentTimer, forMode: RunLoopMode.commonModes)
        }
    }
    
    func creteTimer(time:TimeInterval) -> Timer {
        
        return Timer(timeInterval: time, repeats: true) {(timer:Timer) in
            
            var upDownDelta:CGFloat = 0
            var leftRightDelta:CGFloat = 0
            // 手势方向
            switch self.direction {
            case .up:
                upDownDelta = -itemDelta
                leftRightDelta = 0
            case .down:
                upDownDelta = itemDelta
                leftRightDelta = 0
            case .left:
                upDownDelta = 0
                leftRightDelta = -itemDelta
            case .right:
                upDownDelta = 0
                leftRightDelta = itemDelta
            }
            
            // 蛇的动作
            let firstRect = self.snake.bodyCenterArray.first!
            let newRect = CGRect(x: firstRect.origin.x + leftRightDelta, y: firstRect.origin.y + upDownDelta, width: firstRect.width, height: firstRect.height)
            self.snake.bodyCenterArray.insert(newRect, at: 0)
            self.snake.bodyCenterArray.removeLast()
            self.snake.snakeHead = self.snake.bodyCenterArray.first!
            
            // 边界判断
            guard self.snake.snakeHead.origin.x > 0 else{
                self.gameover()
                return
            }
            guard self.snake.snakeHead.origin.y > 0 else{
                self.gameover()
                return
            }
            guard self.snake.snakeHead.origin.x < (screenWidth)else{
                self.gameover()
                return
            }
            guard self.snake.snakeHead.origin.y < (screenHeight)else{
                self.gameover()
                return
            }
            
            // 蛇身判断
            for i in 1...(self.snake.bodyCenterArray.count - 1){
                let rect = self.snake.bodyCenterArray[i]
                if self.snake.snakeHead.intersects(rect) {
                    self.gameover()
                    return
                }
            }
            
            // 吃东西
            let eat = self.snake.snakeHead.intersects(self.food.frame)
            if  eat {
                let lastRect = self.snake.bodyCenterArray.last!
                let newLastRect = CGRect(x: Int(lastRect.origin.x - leftRightDelta), y: Int(lastRect.origin.y - upDownDelta), width:Int(lastRect.width), height: Int(lastRect.height))
                self.snake.bodyCenterArray.append(newLastRect)
                self.food.snakeBodyArray = self.snake.bodyCenterArray
                self.food.randomPosition()
            }
            
            self.snake.setNeedsDisplay()
        }
    }
    
    
    
    //================================================================================
    // MARK:- target action
    //================================================================================
    func swipeScreen(gesture:UISwipeGestureRecognizer){
    
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            if direction == .right {
                return
            }
            direction = .left
        case UISwipeGestureRecognizerDirection.right:
            if direction == .left {
                return
            }
            direction = .right
        case UISwipeGestureRecognizerDirection.up:
            if direction == .down {
                return
            }
            direction = .up
        case UISwipeGestureRecognizerDirection.down:
            if direction == .up {
                return
            }
            direction = .down
        default:
            print("错误")
        }
    }
    
    func pressScreen(gesture:UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case UIGestureRecognizerState.began:
            startTimer(time: 0.05)
        case UIGestureRecognizerState.cancelled,UIGestureRecognizerState.failed,UIGestureRecognizerState.ended:
            startTimer(time: 0.2)
        default:
            print("错误")
        }
    }
    
    
    
    //================================================================================
    // MARK:- deinit
    //================================================================================
    
    deinit {
        currentTimer?.invalidate()
        currentTimer = nil
    }
    
    //================================================================================
    // MARK:- noticeview delegate
    //================================================================================
    func noticeViewChoseRestart() {
        gameStart()
        notice.hide()
    }
    
    
}

