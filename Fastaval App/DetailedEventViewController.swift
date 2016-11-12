//
//  DetailedEventViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 06/11/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class DetailedEventViewController: UIViewController {

    private var event : ProgramEvent?

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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lang = Directory.sharedInstance.getAppSettings()?.getLanguage() ?? AppLanguage.english
        
        event = Directory.sharedInstance.getProgram()!.getCurrentEvent()
        
        if event != nil {
            switch lang {
            case .danish: self.navigationItem.title = event!.titleDa
                textView.text = event?.descriptionDa
            case .english: self.navigationItem.title = event!.titleEn
                textView.text = event?.descriptionEn
            }
        }
        
        author.text = "Author(s): ".localized(lang: lang.toString()) + (event?.author)!
        
        adjustSize(textView)
        adjustSize(author)
        
        var scrollViewSize = scrollView.bounds.size
        scrollViewSize.height = textView.bounds.height + author.bounds.height + 10
        scrollView.contentSize = scrollViewSize
        
//        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
//        textView.addConstraint(aspectRatioTextViewConstraint)
        
    }
    
    private func adjustSize(_ view : UITextView) {
        let textContentSize = view.sizeThatFits(view.bounds.size)
        
        var frame = view.frame
        frame.size.height = textContentSize.height
        view.frame = frame

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
