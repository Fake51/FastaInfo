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

    func getSubscriberId() -> String {
        return uuid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.disableTabs()
        
        let broadcaster = Broadcaster.sharedInstance
        _ = broadcaster.subscribe(self, messageKey: AppMessages.MapType, subScriberId: self.getSubscriberId())
            .subscribe(self, messageKey: AppMessages.ProgramType, subScriberId: self.getSubscriberId())
            .subscribe(self, messageKey: AppMessages.UserType, subScriberId: self.getSubscriberId())
    }
    
    func disableTabs() {
        
        for i in [Tabs.barcode.rawValue, Tabs.map.rawValue, Tabs.program.rawValue, Tabs.myFastaval.rawValue] {
            self.setIconState(i, state: false)
        }
        
    }
    
    func setIconState(_ index: Int, state: Bool) {
        if let tabBarItems = self.tabBar.items as AnyObject as? NSArray {
            if let tabBarItem = tabBarItems[index] as? UITabBarItem {
                tabBarItem.isEnabled = state
            }
            
        }
    }

    func receive(_ message: Message) {
        switch message {
        case AppMessages.user:
            self.setIconState(Tabs.myFastaval.rawValue, state: true)
            self.setIconState(Tabs.barcode.rawValue, state: true)
            break
        default:
            break
        }
        
    }
    
    /*
    func checkForProgramData(days: [String: ProgramDay]) -> Void {
        if days.count > 0 {
            let enable : dispatch_block_t = { [weak self] in
                self?.setIconState(3, state: true)
            }
            
            dispatch_async(dispatch_get_main_queue(), enable)
        }
    }
*/
}
