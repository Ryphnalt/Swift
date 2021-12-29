//
//  AppDelegate.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/22.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? {
        didSet {
            // 關閉黑暗模式(因為 Xcode 10 不支援 overrideUserInterfaceStyle API 所以用             #if compiler(>=5.1)，未來改用 Xcode 11 包版，可以刪掉 Macro 判斷式)
            #if compiler(>=5.1)
            if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                window?.overrideUserInterfaceStyle = .light
            }
            #endif
        }
    }

//    weak var delegate: AppDelegateDelegate?

    let mainTabBarController = TabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()

        return true
    }
    
}

