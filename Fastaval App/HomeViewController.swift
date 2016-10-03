//
//  FirstViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 04/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Subscriber {

    @IBOutlet weak var upperHomeContainer: UIView!
    
    @IBOutlet weak var lowerHomeContainer: UIView!
    
    fileprivate var lastUpperView: UIViewController?

    fileprivate var lastLowerView: UIViewController?
    
    fileprivate var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.setUpperView()
        self.setLowerView()
    }

    func setUpperView() {
        var id : String
        
        switch Directory.sharedInstance.getParticipant()!.getState() {
        case ParticipantState.notLoggedIn, ParticipantState.failedLogin:
            id = WidgetIdentifiers.Login.rawValue
            break
        
        case ParticipantState.loggedInCheckedIn:
            id = WidgetIdentifiers.Overview.rawValue
            break;
            
        case ParticipantState.loggedInNotCheckedIn:
            id = WidgetIdentifiers.Overview.rawValue
            break
        
        case ParticipantState.notReady:
            id = WidgetIdentifiers.Placeholder.rawValue
            break
            
        }
        
        switchUpperView(id)
    }
    
    func setLowerView() {
        var id : String
        
        switch Directory.sharedInstance.getNews()!.getState() {
        case NewsState.notReady:
            id = WidgetIdentifiers.Placeholder.rawValue
        }

        switchLowerView(id)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.UserType, subScriberId: uuid)
            .subscribe(self, messageKey: AppMessages.NewsType, subScriberId: uuid)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.UserType, subScriberId: uuid)
    }
    
    func switchUpperView(_ view: String) {
        if let _ = lastUpperView {
            lastUpperView?.willMove(toParentViewController: nil)
        }
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: view)
        
        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: upperHomeContainer.frame.size.width, height: upperHomeContainer.frame.size.height);
        upperHomeContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        lastUpperView = viewController
    }

    func switchLowerView(_ view: String) {
        if let _ = lastLowerView {
            lastLowerView?.willMove(toParentViewController: nil)
        }
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: view)
        
        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: lowerHomeContainer.frame.size.width, height: lowerHomeContainer.frame.size.height);
        lowerHomeContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        lastLowerView = viewController
    }
    
    
    func receive(_ message: Message) {
        switch message {
        case AppMessages.user:
            setUpperView()
            break
            
        case AppMessages.news:
            setLowerView()
            break
        
        default:
            break
        }
    }
}

