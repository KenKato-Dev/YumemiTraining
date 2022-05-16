//
//  AppDelegate.swift
//  YumemiTraining
//
//  Created by 加藤研太郎 on 2022/03/20.
//

import UIKit
//アプリ立ち上がり、Scene構築時、アプリ終了時に呼ばれるもの
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //上記の通りアプリが立ち上がった際に呼ばれる
        print("applicationのdidFinishLaunchingWithOptionsが呼ばれた")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        //scene構築中に呼ばれる、アプリ起動中の状態変化に対応するのはSceneDelegate
        print("applicationのconfigurationForConnectingが呼ばれた")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        //アプリが閉じられた際に呼ばれる
        print("applicationのdidDiscardSceneSessionsが呼ばれた")
    }


}

