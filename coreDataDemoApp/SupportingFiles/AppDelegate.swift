//
//  AppDelegate.swift
//  coreDataDemoApp
//
//  Created by Никита Микрюков on 01.10.2020.
//  Copyright © 2020 Никита Микрюков. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //инцилиззация главного экрана
        window = UIWindow(frame: UIScreen.main.bounds)
        // этот метод делать экрна видимым и ключевым
        window?.makeKeyAndVisible()
        // что запускается в начале приложеня 
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        return true
    }
    
}
