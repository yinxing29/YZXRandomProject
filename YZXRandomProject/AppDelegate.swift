//
//  AppDelegate.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/4/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let vc = ViewController()
        let naVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = naVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

