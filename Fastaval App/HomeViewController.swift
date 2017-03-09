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
    
    fileprivate var lastUpperView: UIViewController?
    
    fileprivate var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.automaticallyAdjustsScrollViewInsets = false

        self.setUpperView()
    }

    func setUpperView() {
        var id : String
        
        switch Directory.sharedInstance.getParticipant()!.getState() {
        case ParticipantState.notLoggedIn, ParticipantState.failedLogin:
            id = WidgetIdentifiers.Login.rawValue
            break
        
        case ParticipantState.loggedInCheckedIn, ParticipantState.loggedInNotCheckedIn:
            id = WidgetIdentifiers.Overview.rawValue
            break;
            
        case ParticipantState.notReady:
            id = WidgetIdentifiers.Placeholder.rawValue
            break
            
        }
        
        switchUpperView(id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.UserType)
            .subscribe(self, messageKey: AppMessages.NewsType)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.UserType)
    }
    
    func switchUpperView(_ view: String) {
        if let lastInsert = lastUpperView {
            (lastInsert as! EmbeddedViewController).setParentViewController(nil)
            lastInsert.willMove(toParentViewController: nil)
            lastInsert.view.removeFromSuperview()
            lastInsert.removeFromParentViewController()
        }
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: view)

        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: upperHomeContainer.frame.size.width, height: upperHomeContainer.frame.size.height);
        upperHomeContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        lastUpperView = viewController
        
        let embeddable = viewController as! EmbeddedViewController
        embeddable.setParentViewController(self)
    }
    
    func receive(_ message: Message) {
        switch message {
        case AppMessages.user:
            setUpperView()
            break
            
        default:
            break
        }
    }
}

