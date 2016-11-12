//
//  ProgramTableViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 20/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class ProgramTableViewController: UITableViewController {

    var dataObject : ProgramDate?
    
    var language : AppLanguage?
    
    var parentController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let lang = Directory.sharedInstance.getAppSettings()?.getLanguage() else {
            language = AppLanguage.english
            return
        }
        
        language = lang
        self.tableView.reloadData()

    }
    
    // MARK: - Table view data source

    private func getSection(_ index : Int) -> ProgramTimeslot? {
        guard let timeslots = dataObject?.getSortedPublicTimeslots() else {
            return nil
        }
        
        if index >= timeslots.count {
            return nil
        }
        
        return timeslots[index]
    }
    
    private func getSectionCell(_ sectionIndex : Int, _ cellIndex : Int) -> ProgramEvent? {
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
        // #warning Incomplete implementation, return the number of sections
        guard let timeslots = dataObject?.getPublicTimeslots() else {
            return 0
        }
        
        return timeslots.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let timeslot = getSection(section) else {
            return 0
        }
        
        return timeslot.events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard let event = getSectionCell(indexPath[0], indexPath[1]) else {
            return cell
        }

        switch language! {
        case AppLanguage.english: cell.textLabel?.text = event.titleEn
        case AppLanguage.danish: cell.textLabel?.text = event.titleDa
        }
        
        // Configure the cell...

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}