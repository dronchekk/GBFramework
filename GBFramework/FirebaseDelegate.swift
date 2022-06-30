//
//  FirebaseDelegate.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 28.06.2022.
//

import UIKit
import AudioToolbox
import AVFoundation
import SwiftUI

class FirebaseDelegate: NSObject {

    private let idScheduledNotificationToComeBack = "idScheduledNotificationToComeBack"

    init(factory: Factory) {
        super.init()

        let currentNotificationCenter = UNUserNotificationCenter.current()
        currentNotificationCenter.delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        currentNotificationCenter.requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else {
                print("failed register fcm")
                return
            }
        }

        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: Firebase Delegate
extension FirebaseDelegate: /*MessagingDelegate,*/ UNUserNotificationCenterDelegate {

    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]) {
        print("notification got")
        print(userInfo)
    }

    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        print("register apns token")
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("failed register fcm")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Message was received in foreground
        AudioServicesPlaySystemSound(SystemSoundID(1007))
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        didReceiveRemoteNotification(notification.request.content.userInfo)
//         Dont need to show as a push message
//         completionHandler([.alert, .sound])
    }

    /*func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
     guard let fcmToken = fcmToken else { return }
     print("save token")
     }*/
}

// MARK: - Add notifcaiton
extension FirebaseDelegate {

    private func sendNotification(id: String, content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger)
        let currentNotificationCenter = UNUserNotificationCenter.current()
        currentNotificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func addScheduledNotificationToComeBack() {
        let content = UNMutableNotificationContent()
        content.title = "Возвращайтесь!"
        content.subtitle = "Пора к нам заглянуть!"
        content.body = "Куда вы пропали?! Мы так долго не видели вас!"
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10, // 10 seconds
            repeats: false
        )

        sendNotification(
            id: idScheduledNotificationToComeBack,
            content: content,
            trigger: trigger)
    }
}
