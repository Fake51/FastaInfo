//
//  AppDelegate.swift
//  Fastaval App
//
//  Created by Peter Lind on 04/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.executeMigrations()

//        clean()
        
        self.doAppSetup()

        registerForPushNotifications(application: application)
        
        return true
    }
/*
    func clean() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        
    }
  */  
    func doAppSetup() {
        let api = InfosysApi()
        
        let directory = Directory.sharedInstance
        let appSettings = AppSettings()
        let locationProvider = FileLocationProvider()
        
        _ = directory.setItem(appSettings)
            .setItem(Participant(infosysApi: api, settings: appSettings))
            .setItem(locationProvider)
            .setItem(Program(infosysApi: api, settings: appSettings))
            .setItem(FvMap(infosysApi: api, settings: appSettings, locationProvider: locationProvider))
            .setItem(appSettings)
            .setItem(Barcode(infosysApi: api, settings: appSettings))
        
        let _ = UpdateScheduler(appSettings: appSettings)
        
        handleFirstRun(directory.getAppSettings()!)
        
        directory.getMap()!.initialize()
        directory.getProgram()!.initialize()
        directory.getParticipant()!.initialize()
        directory.getBarcode()!.initialize()
        
        
    }

    func handleFirstRun(_ settings : AppSettings) {
        if !settings.firstRun {
            return
        }

        guard let programAsset = NSDataAsset(name: "activities") else {
            return
        }
        
        guard let mapAsset = Bundle.main.url(forResource: "map2017", withExtension: "png") else {
            return
        }
        

        Directory.sharedInstance.getMap()!.initFromAsset(mapAsset)
        Directory.sharedInstance.getProgram()!.initFromAsset(programAsset)
 
        settings.markDoneFirstRun()
    }
    
    func executeMigrations() {
        let config = Realm.Configuration(
            schemaVersion: 12,
            migrationBlock: { migration, oldSchemaVersion in

                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: ParticipantData.className()) {
                        oldObject, newObject in
                        newObject!["checkedIn"] = false
                        newObject!["category"] = ""
                        newObject!["barcodeId"] = 0
                    }
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let _ = FvForegroundAlert(alertTime: notification.fireDate!, alertText: notification.alertBody!, duration: 10)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted) {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    guard let settings = Directory.sharedInstance.getAppSettings() else {
                        return
                    }
                    
                    if settings.getUseNotifications() {
                        DispatchQueue.main.async {
                            let _ = settings.setUseNotifications(false)
                        }
                    }
                }
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
        }
        
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types.rawValue > 0 {
            application.registerForRemoteNotifications()
            return
            
        }
        
        guard let settings = Directory.sharedInstance.getAppSettings() else {
            return
        }
        
        if settings.getUseNotifications() {
            DispatchQueue.main.async {
                let _ = settings.setUseNotifications(false)
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("wut")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let _ = FvForegroundAlert(alertTime: notification.date, alertText: notification.request.content.body, duration: 10)
    }
}

