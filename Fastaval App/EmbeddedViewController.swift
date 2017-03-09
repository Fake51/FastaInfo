//
//  EmbeddedViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/12/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class EmbeddedViewController : UIViewController {
    var embeddingViewController : UIViewController?
    
    public func setParentViewController(_ controller : UIViewController?) {
        self.embeddingViewController = controller
    }
}
