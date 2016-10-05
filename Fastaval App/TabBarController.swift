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

        self.updateTabs()
        
        let broadcaster = Broadcaster.sharedInstance
        _ = broadcaster.subscribe(self, messageKey: AppMessages.MapType, subScriberId: self.getSubscriberId())
            .subscribe(self, messageKey: AppMessages.ProgramType, subScriberId: self.getSubscriberId())
            .subscribe(self, messageKey: AppMessages.UserType, subScriberId: self.getSubscriberId())
    }
    
    func updateTabs() {
        setMapState()
        setBarcodeState()
        setMyFastavalState()
        setProgramState()        
    }

    private func setBarcodeState() {
        setIconState(Tabs.barcode.rawValue, state: false)
    }
    
    private func setProgramState() {
        setIconState(Tabs.program.rawValue, state: false)
    }

    private func setMyFastavalState() {
        if let participant = Directory.sharedInstance.getParticipant() {
            switch participant.getState() {
            case ParticipantState.loggedInCheckedIn, ParticipantState.loggedInNotCheckedIn:
                setIconState(Tabs.myFastaval.rawValue, state: true)
                break
                

            default:
                setIconState(Tabs.myFastaval.rawValue, state: false)
            }
        }

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
    
    func receive(_ message: Message) {
        updateTabs()
    }
}
