//
//  ProgramTableViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 20/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class ProgramTableViewController: UITableViewController, Subscriber {

    var dataObject : ProgramDate?
    
    var language : AppLanguage?
    
    var parentController : UIViewController?
    
    var timeslots = [ProgramTimeslot]()
    
    fileprivate var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    func receive(_ message: Message) {
        timeslots = dataObject?.getSortedPublicTimeslots() ?? [ProgramTimeslot]()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let lang = Directory.sharedInstance.getAppSettings()?.getLanguage() else {
            language = AppLanguage.english
            return
        }
        
        language = lang

        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.ProgramType)
        
        timeslots = dataObject?.getSortedPublicTimeslots() ?? [ProgramTimeslot]()

        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.ProgramType)
    }
    
    // MARK: - Table view data source

    private func getSection(_ index : Int) -> ProgramTimeslot? {
        
        if index >= timeslots.count {
            return nil
        }
        
        return timeslots[index]
    }
    
    private func getSectionCell(_ sectionIndex : Int, _ cellIndex : Int) -> ProgramEventTimeslot? {
        guard let timeslot = getSection(sectionIndex) else {
            return nil
        }
        
        let events = timeslot.getSortedPublicEvents(language!)
        
        if events.count <= cellIndex {
            return nil
        }
        
        return events[cellIndex]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return timeslots.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let language = Directory.sharedInstance.getAppSettings()?.getLanguage() ?? AppLanguage.english
        
        guard let timeslot = getSection(section) else {
            return 0
        }
        
        return timeslot.getSortedPublicEvents(language).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FvProgramItem", for: indexPath) as! FvProgramItemTableViewCell

        guard let slot = getSectionCell(indexPath[0], indexPath[1]) else {
            return cell
        }

        switch language! {
        case AppLanguage.english: cell.programTitle?.text = slot.event!.titleEn
        case AppLanguage.danish: cell.programTitle?.text = slot.event!.titleDa
        }
        
        if let iconId = slot.event!.getEventIconId() {
            cell.programIcon?.image = UIImage(imageLiteralResourceName: iconId)
            
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "HH:mm"

        let thisSection = getSection(section)
        
        return dayFormatter.string(from: (thisSection?.time)!)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        Directory.sharedInstance.getProgram()!.setCurrentEvent(getSectionCell(indexPath[0], indexPath[1])!)
        
        parentController?.performSegue(withIdentifier: "DetailedEventSegue", sender: parentController)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    func setParent(_ parent : UIViewController) {
        parentController = parent
    }

}
