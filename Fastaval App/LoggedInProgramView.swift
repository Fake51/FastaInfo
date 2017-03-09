//
//  LoggedInProgramView.swift
//  Fastaval App
//
//  Created by Peter Lind on 23/11/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class LoggedInProgramView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
        }
    }

}
