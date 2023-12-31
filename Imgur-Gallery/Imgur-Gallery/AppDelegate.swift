//
//  AppDelegate.swift
//  Imgur-Gallery
//
//  Created by Saifali Terdale on 14/06/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let apimanager = ApiManager()
    static var realDelegate: AppDelegate?
    internal class var instance: AppDelegate {
        get {

            if Thread.isMainThread{
                    return UIApplication.shared.delegate as! AppDelegate;
                }
                let dg = DispatchGroup();
                dg.enter()
                DispatchQueue.main.async{
                    realDelegate = UIApplication.shared.delegate as? AppDelegate;
                    dg.leave();
                }
                dg.wait();
                return realDelegate!;

//            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

