//
//  AppDelegate.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

// This project uses no storyboard initialization, init the window and the basic viewcontroller from the AppDelegate
// because we target iOS 11+, the Scene delegate boilerplate is removed.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var model = Model()
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
            // on 13+ we work with SceneDelegate
        } else {
            // Init the window and the main controller
            let window = UIWindow(frame: UIScreen.main.bounds)

            let viewController = MainViewController(collectionViewLayout: UICollectionViewFlowLayout())
            let navigationController = UINavigationController(rootViewController: viewController)
            model.start(viewController)

            window.rootViewController = navigationController
            window.makeKeyAndVisible()

            self.window = window
        }
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
