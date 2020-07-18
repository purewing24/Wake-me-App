//
//  AppDelegate.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/04.
//  Copyright © 2020 松田羽純. All rights reserved.
//
// 進行状況：sleepVCに遷移できない、タイムラインから前日分のアラーム消すやり方わからない(createdateの条件分け)、ステータスと画像繋がってない
// 完了：ユーザー登録、ログインログアウト、退会、時間セット

import UIKit
import NCMB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        NCMB.setApplicationKey("77830a927b4672df8744114142e23a29346c8de22e67fa0cd18660af74c0247e",clientKey:"88b20bf61fb0db386cfed15fd8a9a2f21ea527fb98aa2f3c560339469d8cb0b2")
        let ud = UserDefaults.standard
        let isLogin = ud.bool(forKey: "isLogin")
        //       let window = UIWindow(windowScene: scene as! UIWindowScene)
        if isLogin == true {
            // ログイン中だったら
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
            self.window?.rootViewController = rootViewController
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
            
        } else {
            // ログインしていなかったら
            
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            self.window?.rootViewController = rootViewController
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
}

