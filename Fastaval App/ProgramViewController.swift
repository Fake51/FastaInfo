//
//  ProgramViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 19/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    private var pageContent : Results<ProgramDate>?
    
    private var index = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        setProgram()
        
        self.delegate = self
        self.dataSource = self

        let startingViewController: ProgramTableViewController = viewControllerAtIndex(0)!
        
        self.navigationController?.view.backgroundColor = UIColor.white
        
        self.setViewControllers(
            [startingViewController],
            direction: .forward,
            animated: false, completion: nil)

        setNavItems(index)
    }
    
    private func setNavItems(_ newIndex : Int) {
        setLeftNavButton(newIndex)
        setNavTitle(newIndex)
        setRightNavButton(newIndex)
    }

    private func setNavTitle(_ newIndex : Int) {
        guard let item = viewControllerAtIndex(newIndex) else {
            return
        }
        
        self.navigationItem.title = item.dataObject?.getHumanFriendlyDate()

    }
    
    dynamic func activateNext() {
        index += 1

        guard let nextController = self.viewControllerAtIndex(index)        else {
            return
        }
        
        self.setViewControllers([nextController], direction: .forward, animated: false, completion: nil)
        
        setNavItems(index)
    }

    dynamic func activatePrevious() {
        if index - 1 < 0 {
            return
        }
        
        index -= 1
        
        guard let nextController = self.viewControllerAtIndex(index)        else {
            return
        }
        
        self.setViewControllers([nextController], direction: .forward, animated: false, completion: nil)
        
        setNavItems(index)
    }

    private func setLeftNavButton(_ newIndex : Int) {
        if newIndex - 1 < 0 {
            self.navigationItem.leftBarButtonItem = nil
            return
        }
        
        guard let previousViewController : ProgramTableViewController = viewControllerAtIndex(newIndex - 1) else {
            self.navigationItem.leftBarButtonItem = nil
            return
        }

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: previousViewController.dataObject?.getHumanFriendlyDate(), style: .plain, target: self, action: #selector(self.activatePrevious))
        
    }

    private func setRightNavButton(_ newIndex : Int) {
        guard let nextViewController : ProgramTableViewController = viewControllerAtIndex(newIndex + 1) else {
            self.navigationItem.rightBarButtonItem = nil
            return
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nextViewController.dataObject?.getHumanFriendlyDate(), style: .plain, target: self, action: #selector(self.activateNext))

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let newIndex = indexofViewController(viewController: pageViewController.viewControllers!.first! as! ProgramTableViewController)

        if newIndex == NSNotFound {
            return
        }
        
        index = newIndex

        setNavItems(newIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexofViewController(viewController: viewController as! ProgramTableViewController)

        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
    
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
