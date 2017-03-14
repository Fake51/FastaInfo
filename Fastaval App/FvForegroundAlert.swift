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

    private var alertTimer : Timer?

    init(alertTime : Date, alertText : String) {
        self.alertTime = alertTime
        self.alertText = alertText

        DispatchQueue.main.async {
            self.alertTimer = Timer.scheduledTimer(timeInterval: alertTime.timeIntervalSinceNow, target: self, selector: #selector(self.displayAlert), userInfo: nil, repeats: false)
            
        }
    }
    
    func remove() {
        guard let timer = alertTimer, timer.isValid else {
            return
        }
        
        timer.invalidate()
    }

    @objc func displayAlert(_ timer : Timer) {
        DispatchQueue.main.async {
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 8
            let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : UIFont.systemFont(ofSize: 12)]
            
            let view = UIView()
            let text = UITextView()
            text.attributedText = NSAttributedString(string: self.alertText, attributes: attributes)
            
            text.bounds = text.frame.insetBy(dx: 10.0, dy: 5.0)

            view.frame.size.width = viewController.view.bounds.size.width
            view.addSubview(text)
            text.frame.size.width = view.frame.size.width
            
            let contentSize = text.sizeThatFits(text.bounds.size)
            text.frame.size.height = contentSize.height
            view.frame.size.height = text.frame.height + 1
 
            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x: 0, y: view.frame.height - 1, width: view.frame.width, height: 0.7)

            view.layer.addSublayer(border)

            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(view, duration: 5)
        }
    }
}
