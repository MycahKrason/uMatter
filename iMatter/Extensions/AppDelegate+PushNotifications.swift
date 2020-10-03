//
//  AppDelegate+PushNotifications.swift
//  iMatter
//
//  Created by Mycah on 11/1/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UserNotifications
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    // Register for push notifications
    func registerForPushNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    self.scheduleNotification()
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func scheduleNotification() {
        print("\n\nscheduleNotification\n\n")
        //Clear notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        //Schedule new notifications
        for count in 0...60 {
            let dayTimeInterval = Double(count)
            
            //Set up content
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Daily Affirmation"
            notificationContent.body = ListOfAffirmations().listOfAllAffirmations.randomElement()!
            notificationContent.sound = .default
            
            //Set up Trigger
            let targetDate = Date().addingTimeInterval(86400 * dayTimeInterval)
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
            dateComponents.hour = 10
            dateComponents.minute = 30
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //Set up request
            let request = UNNotificationRequest(identifier: "\(count)", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error : Error?) in
                if let err = error {
                    print("\nThere was an error adding request: \(err)")
                }
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    
    func application(received remoteMessage: MessagingRemoteMessage) {
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
}
