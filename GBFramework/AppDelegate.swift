//
//  AppDelegate.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 15.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var factory: Factory = { return Factory() }()

    lazy var firebase = FirebaseDelegate(factory: factory)
    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().titleTextAttributes = Styles.shared.getAttributes(Styles.shared.view.navbarPrC)
        UINavigationBar.appearance().tintColor = Styles.shared.getFontColor(Styles.shared.view.navbarPrC)

        UINavigationBar.appearance().backIndicatorImage = UIImage(named: Assets.appbarBack)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: Assets.appbarBack)

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0.1), NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let router = RouterImpl(rootController: navigationController)
        appCoordinator = AppCoordinator(router: router, coordinatorFactory: factory)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator?.start()

        return true
    }
    
    let blurTag = 10001
    func applicationDidEnterBackground(_ application: UIApplication) {
        DialogBuilder.shared.showBlurPopup()

        // Another way withoud top level popup
        //let blurVC = BlurPopup()
        //blurVC.view.tag = blurTag
        //window?.addSubview(blurVC.view)
        firebase.addScheduledNotificationToComeBack()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DialogBuilder.shared.removeBlurPopup()

        // Another way without top level popup
        //let blurView = window?.viewWithTag(blurTag)
        //blurView?.removeFromSuperview()
    }
}

// MARK: - Notifications
extension AppDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
        firebase.didReceiveRemoteNotification(userInfo)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        firebase.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        firebase.didFailToRegisterForRemoteNotificationsWithError(error)
    }
}
