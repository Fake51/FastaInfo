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


class LoginViewController : UIViewController,  Subscriber {
    fileprivate let uuid = UUID().uuidString

    @IBOutlet weak var participantFieldId: UITextField!

    @IBOutlet weak var passwordFieldId: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func attemptLogin(_ sender: UIButton) {

        var id_number = 0
        var password = ""
        print(participantFieldId.layer.cornerRadius)
        
        print(participantFieldId.layer.borderColor)
            print(participantFieldId.layer.masksToBounds)
            print(participantFieldId.layer.borderWidth)

        
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
        
//            store.dispatch(Actions.AttemptLogin(id_number, password))
        }
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
    
    func receive(_ message: Message) {
    }
    
    func getSubscriberId() -> String {
        return uuid
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}