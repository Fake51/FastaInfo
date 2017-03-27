//
//  FVTabBar.swift
//  FV tab
//
//  Created by Fake on 12/11/15.
//  Copyright © 2015 Fastaval. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, Subscriber {

    fileprivate let uuid = UUID().uuidString

    private var barcodeController : UIViewController?
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor.orange
        self.tabBar.tintColor = UIColor.black
        
        self.updateTabs()
        
        let broadcaster = Broadcaster.sharedInstance
        _ = broadcaster.subscribe(self, messageKey: AppMessages.MapType)
            .subscribe(self, messageKey: AppMessages.ProgramType)
            .subscribe(self, messageKey: AppMessages.UserType)
            .subscribe(self, messageKey: AppMessages.SettingsType)
            .subscribe(self, messageKey: AppMessages.BarcodeType)
    }
    
    func updateTabs() {
        setMapState()
        setBarcodeState()
        setProgramState()
    }

    private func setBarcodeState() {
        var controllers = self.viewControllers

        guard let barcode = Directory.sharedInstance.getBarcode() else {
            
            if controllers?.count ?? 0 > Tabs.barcode.rawValue && barcodeController == nil {
                barcodeController = controllers?.remove(at: Tabs.barcode.rawValue)
                self.viewControllers = controllers
            }
            
            return
        }

        if controllers?.count ?? 0 > Tabs.barcode.rawValue {
            if barcodeController == nil && barcode.getState() == .notReady {
                barcodeController = controllers?.remove(at: Tabs.barcode.rawValue)
                self.viewControllers = controllers
                return
            }
            
            if barcodeController != nil && barcode.getState() == .ready {
                controllers?.insert(barcodeController!, at: Tabs.barcode.rawValue)
                barcodeController = nil
                self.viewControllers = controllers
            }
        }

    }
    
    private func setProgramState() {
        guard let program = Directory.sharedInstance.getProgram() else {
            setIconState(Tabs.program.rawValue, state: false)
            return
        }
        
        setIconState(Tabs.program.rawValue, state: program.getState() == ProgramState.ready)
    }
    
    func setIconState(_ index: Int, state: Bool) {
        if let tabBarItems = self.tabBar.items {
            if let tabBarItem = tabBarItems[index] as? UITabBarItem {
                tabBarItem.isEnabled = state
            }
        }
        
    }

    fileprivate func setMapState() {
        if let map = Directory.sharedInstance.getMap() {
            switch map.getState() {
            case FvMapState.notReady:
                setIconState(Tabs.map.rawValue, state: false)
                break
                
            case FvMapState.ready:
                setIconState(Tabs.map.rawValue, state: true)
            }
        }
    }
    
    func updateLanguage() {
        guard let items = self.tabBar.items else {
            return
        }
        
        guard let language = Directory.sharedInstance.getAppSettings()?.getLanguage().toString() else {
            return
        }

        var modifier = 0
        
        if items.count == 4 {
            modifier -= 1
        }
        
        items[Tabs.home.rawValue].title = Tabs.getTranslationKey(Tabs.home).localized(lang: language)
        items[Tabs.settings.rawValue + modifier].title = Tabs.getTranslationKey(Tabs.settings).localized(lang: language)
        items[Tabs.map.rawValue + modifier].title = Tabs.getTranslationKey(Tabs.map).localized(lang: language)
        
        if items.count == 5 {
            items[Tabs.barcode.rawValue].title = Tabs.getTranslationKey(Tabs.barcode).localized(lang: language)
        }

        items[Tabs.program.rawValue].title = Tabs.getTranslationKey(Tabs.program).localized(lang: language)
    }
    
    func receive(_ message: Message) {
        switch message {
        case AppMessages.settings:
            updateLanguage()
            
        case AppMessages.map, AppMessages.program, AppMessages.user, AppMessages.barcode:
            fallthrough
        default:
            updateTabs()
        }
    }
}
