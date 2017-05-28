//
//  TouchRecognizer.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

import UIKit.UIGestureRecognizerSubclass

class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    
    var window: UIWindow?
    
    init(target: Any?, action: Selector?, window: UIWindow?) {
        self.window = window
        super.init(target: target, action: action)
    }
    
    let emitterLayer = CAEmitterLayer()
    let cell = CAEmitterCell()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event!)
    
        if let touch = touches.first {
            let position = touch.location(in: (window?.rootViewController! as! UINavigationController).view)
            print(position)
            emitterLayer.emitterPosition = CGPoint(x: position.x, y: position.y)
            
            cell.birthRate = 5
            cell.lifetime = 10
            cell.velocity = 50
            cell.scale = 0.1
            
            cell.emissionRange = CGFloat.pi
            cell.contents = UIImage(named: "spark.png")!.cgImage
            
            emitterLayer.emitterCells?.removeAll()
            emitterLayer.emitterCells = [cell]
            
            
            (window?.rootViewController! as! UINavigationController).visibleViewController!.view.layer.addSublayer(emitterLayer)
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        cell.birthRate = 0
        emitterLayer.removeFromSuperlayer()
        
        self.state = .cancelled
    }
}
