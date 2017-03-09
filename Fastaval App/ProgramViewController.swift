//
//  ProgramViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 19/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, Subscriber {

    fileprivate var uuid = UUID().uuidString
    
    private var pageContent : Results<ProgramDate>?
    
    private var index = 0
    
    func getSubscriberId() -> String {
        return uuid
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        setProgram()
        
        self.delegate = self
        self.dataSource = self

        let startingViewController: ProgramTableViewController = viewControllerAtIndex(0)!

        self.navigationItem.title = startingViewController.dataObject?.getHumanFriendlyDate()
        
        self.setViewControllers(
            [startingViewController],
            direction: .forward,
            animated: false, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.ProgramType)
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.ProgramType)
    }
    
    func receive(_ message: Message) {
        // todo redraw program on program message
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let controller = pageViewController.viewControllers!.first! as! ProgramTableViewController
        
        self.navigationItem.title = controller.dataObject?.getHumanFriendlyDate()

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexofViewController(viewController: viewController as! ProgramTableViewController)

        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
    
        self.index = index

        let view = viewControllerAtIndex(index)

        return view
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexofViewController(viewController: viewController as! ProgramTableViewController)

        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        guard let content = pageContent else {
            return nil
        }
        
        if index >= content.count {
            return nil
            
        }
        
        self.index = index

        let view = viewControllerAtIndex(index)

        return view
    }
    
    private func setProgram() {
        guard let data = Directory.sharedInstance.getProgram()?.getData() else {
            return
        }
        
        self.pageContent = data.sorted(byKeyPath: "dateId")
        return
    }

    func viewControllerAtIndex(_ index: Int) -> ProgramTableViewController? {
        guard let content = pageContent else {
            return nil
        }

        if (content.count == 0 || index >= content.count) {
            return nil
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let dataViewController = storyBoard.instantiateViewController(withIdentifier: "ProgramTable") as! ProgramTableViewController
        
        dataViewController.dataObject = content[index] as ProgramDate
        dataViewController.setParent(self)

        return dataViewController
        
    }
    
    func indexofViewController(viewController: ProgramTableViewController) -> Int {
        if let dataObject = viewController.dataObject {
            guard let content = pageContent else {
                return 0
            }
            
            return content.index(of: dataObject)!
        } else {
            return NSNotFound
        }
    }
}
