//
//  LoginViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 09/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LoginViewController : EmbeddedViewController, Subscriber {
    @IBOutlet weak var participantFieldId: UITextField!

    @IBOutlet weak var passwordFieldId: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginFailedLabel: UILabel!
    
    private var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    @IBAction func attemptLogin(_ sender: UIButton) {

        var id_number = 0
        var password = ""
        
        let participant = Directory.sharedInstance.getParticipant()!
        
        if let id = participantFieldId.text {
            if (Int(id) != nil && Int(id)! > 0) {
                self.markTextfieldValid(participantFieldId)
                id_number = Int(id)!

            } else {
                self.markTextfieldInvalid(participantFieldId)
            }
        } else {
            self.markTextfieldInvalid(participantFieldId)
        }

        
        if (passwordFieldId.text != nil && passwordFieldId.text?.characters.count > 0) {
            self.markTextfieldValid(passwordFieldId)
            password = passwordFieldId.text!
        } else {
            self.markTextfieldInvalid(passwordFieldId)
        }

        if id_number > 0 && password.characters.count > 0 {
            participant.attemptLogin(id_number, password)
        }
    }
    
    func receive(_ message: Message) {
        guard let participant = Directory.sharedInstance.getParticipant() else {
            return
        }
        
        if participant.getState() == ParticipantState.notLoggedIn {
            loginFailedLabel.isHidden = false
        } else {
            loginFailedLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.UserType)
        let language = Directory.sharedInstance.getAppSettings()!.getLanguage()
        
        loginFailedLabel.text = "Login failed".localized(lang: language.toString())
        loginFailedLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.UserType)
    }
    
    func markTextfieldValid(_ field: UITextField) {
        field.layer.borderColor = UIColor.clear.cgColor
        field.layer.borderWidth = 0
        field.layer.cornerRadius = 0
    }
    
    func markTextfieldInvalid(_ field: UITextField) {
        field.layer.borderColor = UIColor.red.cgColor
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderWidth = 1

    }

}
