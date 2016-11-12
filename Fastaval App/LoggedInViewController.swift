//
//  LoggedInViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 05/11/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController, Subscriber {
    private let uuid = UUID().uuidString
    
    @IBOutlet weak var logoutButton: UIButton!

    @IBOutlet weak var participantName: UILabel!

    func getSubscriberId() -> String {
        return uuid
    }

    @IBAction func logParticipantOut(_ sender: AnyObject) {
        guard let participant = Directory.sharedInstance.getParticipant() else {
            return
        }
        
        participant.doLogout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receive(_ message: Message) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lang = Directory.sharedInstance.getAppSettings()?.getLanguage().toString() ?? "en"
        
        logoutButton.setTitle("Log out".localized(lang: lang), for: .normal)
        
        participantName.text = Directory.sharedInstance.getParticipant()?.getName()
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
