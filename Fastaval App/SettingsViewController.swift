//
//  SettingsViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 26/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController : FormViewController, Subscriber {
    
    private var languageSection : Section?
    private var frequencySection : Section?
    private var notificationSection : Section?
    
    private var languageRow : SegmentedRow<String>?
    private var notificationRow : CheckRow?
    private var refreshRateRow : ActionSheetRow<String>?
    
    private var lang : String?
    private var useNotifications : Bool?
    private var refreshRate : RefreshRate?
    
    private let uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.SettingsType)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.SettingsType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSettings()
        
        languageSection = Section("Language".localized(lang: lang!))
        frequencySection = Section("Update frequency".localized(lang: lang!))
        notificationSection = Section("Notifications".localized(lang: lang!))

        languageRow = createLanguageRow()
        notificationRow = createNotificationRow()
        refreshRateRow = createRefreshRateRow()
        
        form +++ languageSection!
            <<< languageRow!
            +++ frequencySection!
            <<< refreshRateRow!
            +++ notificationSection!
            <<< notificationRow!

    }

    private func createRefreshRateRow() -> ActionSheetRow<String> {
        let frequencies = ["Manual".localized(lang: lang!), "5 minutes".localized(lang: lang!), "15 minutes".localized(lang: lang!), "Hourly".localized(lang: lang!), "Daily".localized(lang: lang!)]
        
        return ActionSheetRow<String>() {
            $0.title = "Interval".localized(lang: lang!)
            $0.selectorTitle = "Choose frequency".localized(lang: lang!)
            $0.options = frequencies
            $0.value = refreshRate?.toString().localized(lang: self.lang!)
            }.onChange() {
                let _ = Directory.sharedInstance.getAppSettings()?.setRefreshRate(RefreshRate.parseString($0.value!))
        }
    }
    
    private func createNotificationRow() -> CheckRow {
        return CheckRow() {
            $0.title = "Use alarms/notifications".localized(lang: self.lang!)
            $0.value = useNotifications!
            }.onChange() {
                let _ = Directory.sharedInstance.getAppSettings()?.setUseNotifications($0.value!)
        }

    }
    
    private func createLanguageRow() -> SegmentedRow<String> {
        let languages = ["English", "Dansk"]

        return SegmentedRow<String>() {
            $0.options = languages
            $0.value = lang == "en" ? "English" : "Dansk"
            }.onChange() { row in
                let _ = Directory.sharedInstance.getAppSettings()!.setLanguage(AppLanguage.parseString(row.value!))
        }

    }
    
    private func getSettings() {
        let appSettings = Directory.sharedInstance.getAppSettings()
        lang = appSettings!.getLanguage().toString()
        useNotifications = appSettings!.getUseNotifications()
        refreshRate = appSettings!.getRefreshRate()
        
    }
    
    func updateLanguage() {
        getSettings()
        
        languageSection!.header = HeaderFooterView(title: "Language".localized(lang: lang!))
        notificationSection!.header = HeaderFooterView(title: "Notifications".localized(lang: lang!))
        frequencySection!.header = HeaderFooterView(title: "Update frequency".localized(lang: lang!))

        notificationRow!.title = "Use alarms/notifications".localized(lang: self.lang!)
        refreshRateRow!.title = "Interval".localized(lang: lang!)
        refreshRateRow!.selectorTitle = "New frequency".localized(lang: lang!)
        refreshRateRow!.options = ["Manual".localized(lang: lang!), "5 minutes".localized(lang: lang!), "15 minutes".localized(lang: lang!), "Hourly".localized(lang: lang!), "Daily".localized(lang: lang!)]
        
        switch refreshRate! {
        case .manual:
            refreshRateRow!.value = "Manual".localized(lang: lang!)
        case .fiveMins:
            refreshRateRow!.value = "5 minutes".localized(lang: lang!)
        case .fifteenMins:
            refreshRateRow!.value = "15 minutes".localized(lang: lang!)
        case .oneHour:
            refreshRateRow!.value = "Hourly".localized(lang: lang!)
        case .oneDay:
            refreshRateRow!.value = "Daily".localized(lang: lang!)

        }
        
        notificationRow!.reload()
        refreshRateRow!.reload()
        
        languageSection!.reload()
        notificationSection!.reload()
        frequencySection!.reload()
    }
    
    func receive(_ message: Message) {
        updateLanguage()
    }
}
