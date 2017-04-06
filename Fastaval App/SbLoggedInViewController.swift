//
//  LoggedInViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 05/11/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class SbLoggedInViewController: EmbeddedViewController, UITableViewDelegate, UITableViewDataSource, Subscriber {
    
    @IBOutlet weak var participantName: UILabel!
    
    @IBOutlet weak var programTable: UITableView!
    
    @IBOutlet weak var programTableHeader: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    
    private var uuid = UUID().uuidString
    
    @IBOutlet weak var notCheckedInMessage: UILabel!
    
    @IBOutlet weak var sleepAreaLabel: UILabel!
    
    @IBOutlet weak var sleepAreaInfo: UILabel!
    
    @IBOutlet weak var participantMessages: UITextView!
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    func receive(_ message: Message) {
        refreshContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        
        setupUiElements()
    }
    
    func setupUiElements() {
        programTable.delegate = self
        programTable.dataSource = self
        
        programTable.estimatedRowHeight = 100
        programTable.rowHeight = UITableViewAutomaticDimension
        
        programTableHeader.font = programTableHeader.font.withSize(15)
        
        logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        
        updateButton.addTarget(self, action: #selector(self.manualUpdate), for: .touchUpInside)
        
        notCheckedInMessage.font.withSize(20)
        notCheckedInMessage.textAlignment = .center
    }
    
    func logout(sender: UIButton!) {
        guard let participant = Directory.sharedInstance.getParticipant() else {
            return
        }
        
        participant.doLogout()
    }
    
    func manualUpdate(sender: UIButton!) {
        Broadcaster.sharedInstance.publish(message: AppMessages.remoteSync)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshContent()
        
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.UserType)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.UserType)
    }
    
    private func refreshContent() {
        
        let settings = Directory.sharedInstance.getAppSettings()
        
        let lang = settings?.getLanguage().toString() ?? "en"
        
        if settings?.getRefreshRate() == RefreshRate.manual {
            updateButton.isHidden = false
        } else {
            updateButton.isHidden = true
        }
        
        let participant = Directory.sharedInstance.getParticipant()!
        
        if participant.getState() == ParticipantState.loggedInCheckedIn {
            notCheckedInMessage.isHidden = true
            programTable.isHidden = false
        } else {
            programTable.isHidden = true
            notCheckedInMessage.isHidden = false
        }
        
        notCheckedInMessage.text = "Not checked in yet".localized(lang: lang)
        
        logoutButton.setTitle("Log out".localized(lang: lang), for: .normal)
        
        updateButton.setTitle("Update".localized(lang: lang), for: .normal)
        
        participantName.text = participant.name
        
        sleepAreaLabel.text = "Sleep area:".localized(lang: lang)
        
        sleepAreaInfo.text = participant.getSleepInfoTitle()
        
        participantMessages.text = participant.messages
        
        programTableHeader.text = "My Program".localized(lang: lang)
        
        programTable.reloadData()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = Directory.sharedInstance.getParticipant() else {
            return 0
        }
        
        let days = data.program.map {$0.start.toFvDateString()}
        
        return Array(Set(days)).count
    }
    
    private func getProgramDayArray() -> [String: [ParticipantEvent]] {
        
        var days = [String: [ParticipantEvent]]()
        
        guard let data = Directory.sharedInstance.getParticipant() else {
            return days
        }
        
        for item in data.program {
            let day = item.start.toFvDateString()

            if days[day] == nil {
                days[day] = [ParticipantEvent]()
            }
            
            days[day]!.append(item)
        }
        
        return days
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let days = getProgramDayArray()
        
        return days[Array(days.keys).sorted()[section]]?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let days = getProgramDayArray()
        
        if days.count == 0 {
            return nil
        }
        
        return Array(days.keys).sorted()[section]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = programTable.dequeueReusableCell(withIdentifier: "FvMyProgramItem", for: indexPath) as! FvMyProgramTableViewCell
        
        let days = getProgramDayArray()
        
        if days.count == 0 {
            return cell
        }
        
        guard let cellData = days[Array(days.keys).sorted()[indexPath[0]]]?[indexPath[1]] else {
            return cell
        }
        
        let lang = Directory.sharedInstance.getAppSettings()?.getLanguage().toString() ?? "en"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        cell.myProgramTime?.text = timeFormatter.string(from: cellData.start)
        cell.myProgramTime?.adjustsFontSizeToFitWidth = true

        if let iconId = cellData.getEventIconId() {
            cell.myProgramIcon?.image = UIImage(imageLiteralResourceName: iconId)
        }
        
        cell.myProgramTitle?.text = (lang == "en" ?cellData.titleEn : cellData.titleDa)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let days = getProgramDayArray()
        let program = Directory.sharedInstance.getProgram()!
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let item = days[Array(days.keys).sorted()[indexPath[0]]]?[indexPath[1]] else {
            return
        }
        
        if item.type == "mad" {
            return
        }
        
        guard let event = program.getEventTimeslotById(item.scheduleId) else {
            return
        }
        
        if let map = Directory.sharedInstance.getMap() {
            map.setHighlightedRoom(room: item.activityRoomId != "" ? item.activityRoomId : item.meetingRoomId)
        }
        
        program.setCurrentEvent(event)
        
        embeddingViewController?.performSegue(withIdentifier: "HomeToDetailedEventSegue", sender: embeddingViewController)
    }
}
