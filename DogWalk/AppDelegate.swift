//
//  AppDelegate.swift
//  DogWalk
//
//  Created by 孙雷 on 15/8/6.
//  Copyright (c) 2015年 Guadoo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let navigationController = self.window!.rootViewController as! UINavigationController
        
        let viewController = navigationController.topViewController as! ViewController
        
        viewController.managedContext = coreDataStack.managedObjectContext
        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillTerminate(application: UIApplication) {
        coreDataStack.saveContext()
    }

}

