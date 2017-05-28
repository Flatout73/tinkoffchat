//
//  AppDelegate.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 06.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIGestureRecognizerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tapGesture = SingleTouchDownGestureRecognizer(target: self, action: nil, window: window)
        //tapGesture.delegate = self
        window?.isUserInteractionEnabled = true
        window?.addGestureRecognizer(tapGesture)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // User tapped on screen, do whatever you want to do here.
    
        //if(t)
        return false
    }
    
    let emitterLayer = CAEmitterLayer()
    let cell = CAEmitterCell()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
    }
    
}

