//
//  MapViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 03/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageHtml = "<html><head><style></style>"
        + "<object type='image/svg+xml' data='location.svg' width='1264' height='1032' border='0'></object>"
            + "</html>"

        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        
        webView.loadHTMLString(pageHtml, baseURL: documentsDirectoryURL)
    }
}
