//
//  AppDelegate.swift
//  OnTime
//
//  
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
            let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
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


//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        if (application.applicationState == .active) {
//            print("active")
//        }
//        else if (application.applicationState == .background) {
//            print("background")
//        }
//        else if (application.applicationState == .inactive) {
//            print("inactive")
//        }
//    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
//
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler([.alert,.badge, .sound])
        print(userInfo)

    }
//
////    func userNotificationCenter(_ center: UNUserNotificationCenter,
////                                didReceive response: UNNotificationResponse,
////                                withCompletionHandler completionHandler: @escaping () -> Void) {
////        let userInfo = response.notification.request.content.userInfo
////        print(",,,,,,\(userInfo)")
////        completionHandler()
////
////
////
////
////    }
    @available(iOS 10.0, *)
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           print("Userinfo \(response.notification.request.content.userInfo)")

           var userInfo = NSDictionary()
           userInfo = response.notification.request.content.userInfo as NSDictionary
           print(userInfo)
        coordinateToSomeVC()
   }

//
//    func application(application: UIApplication, didReceiveLocalNotification notification: UNNotificationResponse) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
//        window?.rootViewController = vc
//    }

    private func coordinateToSomeVC()
    {
         let window = UIApplication.shared.windows.first { $0.isKeyWindow }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = storyboard.instantiateViewController(identifier: "NotesVC")
        
        let navController = UINavigationController(rootViewController: yourVC)
        navController.modalPresentationStyle = .fullScreen

        // you can assign your vc directly or push it in navigation stack as follows:
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    
    
    
    
    
    
//
}
