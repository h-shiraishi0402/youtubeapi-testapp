//
//  AppDelegate.swift
//  Youtube
//
//  Created by 白石裕幸 on 2020/12/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    let hours = 19
    let minunte = 00
    
    
    var notifacationGranted = true
    
    var isFirst = true


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //許可を促すアラートを出す
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (grantid, error) in
        
            
            self.notifacationGranted = grantid
            if let error = error{
                print(error)
                
            }
        }
        
        isFirst = false
        setNotifacation()
        
        return true
    }
    
    
    func setNotifacation(){
        var notificationTime = DateComponents()
        var trigger:UNNotificationTrigger
        
        notificationTime.hour = hours
        notificationTime.minute = minunte
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "19jininarimasita"
        content.body = "動画が更新されました"
        content.sound = .default
        
        //通知スタイル
        let reqest = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
        
        //通知をセットする
        UNUserNotificationCenter.current().add(reqest, withCompletionHandler: nil)
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        setNotifacation()
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

