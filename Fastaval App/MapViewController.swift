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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let html = generateHtml() {
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            webView.loadHTMLString(html, baseURL: documentsDirectoryURL)
            
        }
        
    }

    private func getSvgContent() -> String? {
        guard let fileUrl = Directory.sharedInstance.getFileLocationProvider()?.getMapLocation() else {
            return nil
        }
        
        do {
            let svgContent = try String(contentsOfFile: fileUrl.path)
            
            return svgContent
        } catch {
            return nil
        }
        
    }
    
    private func generateHtml() -> String? {
        if let svgContent = getSvgContent() {
            let pageHtmlStart = "<html><head><style>svg {transform: rotate(90deg)} rect {display: none} path {display: none} "
            let pageHtmlMiddle = "</style></head><body>"
            let pageHtmlEnd = "</body></html>"
            
            var id_highlight = ""
            
            if let room = Directory.sharedInstance.getMap()?.getHighlightedRoom() {
                id_highlight = "#" + room + " {display: initial} "
                
                Directory.sharedInstance.getMap()?.setHighlightedRoom(room: nil)
            }

            return pageHtmlStart + id_highlight + pageHtmlMiddle + svgContent + pageHtmlEnd
        }
        
        return nil

        
    }
}
