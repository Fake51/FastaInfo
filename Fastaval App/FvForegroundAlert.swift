//
//  FvForegroundAlert.swift
//  Fastaval App
//
//  Created by Peter Lind on 14/03/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import UIKit
import SwiftOverlays

class FvForegroundAlert {

    private let alertTime : Date
    private let alertText : String

    init(alertTime : Date, alertText : String, duration : Int) {
        self.alertTime = alertTime
        self.alertText = alertText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        DispatchQueue.main.async {
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            
            let view = UIView()
            let width = viewController.view.bounds.width

            let timeLabel = UILabel()
            timeLabel.text = formatter.string(from: (alertTime))
            timeLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            timeLabel.textAlignment = .center
            timeLabel.backgroundColor = .white

            timeLabel.widthAnchor.constraint(equalToConstant: 50)
            
            let body = self.makeBody()
            let title = self.makeTitle()

            title.frame = CGRect(x: 50, y: 0, width: width - 50, height: 50)
            title.frame.size.height = title.sizeThatFits(title.bounds.size).height

            body.frame = CGRect(x: 50, y: title.frame.size.height, width: width - 50, height: 50)
            body.frame.size.height = body.sizeThatFits(body.bounds.size).height
            
            timeLabel.frame.size.height = body.frame.size.height + title.frame.size.height
            
            view.addSubview(timeLabel)
            view.addSubview(body)
            view.addSubview(title)

            view.frame.size.width = viewController.view.bounds.width
            view.frame.size.height = body.frame.size.height + title.frame.size.height

            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x: 0, y: view.frame.height - 1, width: view.frame.width, height: 0.7)
            
            view.layer.addSublayer(border)
            
            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(view, duration: TimeInterval(duration))
        }
    }
    
    private func makeTitle() -> UITextView {
        let text = UITextView()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : UIFont.systemFont(ofSize: 15)]

        text.attributedText = NSAttributedString(string: "Fastaval Reminder", attributes: attributes)
        text.bounds = text.frame.insetBy(dx: 10.0, dy: 5.0)

        return text
    }
    
    private func makeBody() -> UITextView {
        let text = UITextView()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : UIFont.systemFont(ofSize: 12)]
        

        
        text.attributedText = NSAttributedString(string: self.alertText, attributes: attributes)
        text.bounds = text.frame.insetBy(dx: 10.0, dy: 5.0)
        
        return text
    }
    
}
