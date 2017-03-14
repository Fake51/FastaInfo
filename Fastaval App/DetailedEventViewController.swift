//
//  DetailedEventViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 06/11/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class DetailedEventViewController: UIViewController {

    private var timeslot : ProgramEventTimeslot?

    private var scrollView : UIScrollView!
    
    private var textView : UITextView!
    
    private var author : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        author = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        
        textView = UITextView(frame: CGRect(x: 0, y: 30.0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(author)
        scrollView.addSubview(textView)

        view.addSubview(scrollView)
        
        self.view.backgroundColor = UIColor.white

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        self.navigationController?.navigationBar.isHidden = false
         
        let lang = Directory.sharedInstance.getAppSettings()?.getLanguage() ?? AppLanguage.english
        
        timeslot = Directory.sharedInstance.getProgram()!.getCurrentEvent()
      
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSParagraphStyleAttributeName : style]

        
        if timeslot != nil {
            switch lang {
            case .danish: self.navigationItem.title = timeslot!.event!.titleDa
            textView.attributedText = NSAttributedString(string:  (timeslot!.event?.descriptionDa)!, attributes: attributes)
            case .english: self.navigationItem.title = timeslot!.event!.titleEn
                textView.attributedText = NSAttributedString(string:  (timeslot!.event?.descriptionEn)!, attributes: attributes)
            }
        }
        
        textView.font = UIFont.systemFont(ofSize: 15)
        
        author.font = UIFont.systemFont(ofSize: 18)
        
        let authorContent = timeslot?.event?.author ?? ""
        
        if authorContent.characters.count > 0 {
            author.text = "Author(s): ".localized(lang: lang.toString()) + authorContent
            author.isHidden = false
        } else {
            author.isHidden = true
        }
        
        adjustSize(textView)
        adjustSize(author)
        
        var scrollViewSize = scrollView.bounds.size
        scrollViewSize.height = textView.bounds.height + author.bounds.height + 10
        scrollView.contentSize = scrollViewSize
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(segueToMap))
        
    }
    
    dynamic func segueToMap() {
        self.performSegue(withIdentifier: "EventToMapSegue", sender: self)

    }
    
    private func adjustSize(_ view : UITextView) {
        let textContentSize = view.sizeThatFits(view.bounds.size)
        
        var frame = view.frame
        frame.size.height = textContentSize.height
        view.frame = frame

    }

}
