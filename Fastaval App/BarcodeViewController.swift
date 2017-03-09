//
//  SecondViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 04/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class BarcodeViewController: UIViewController, Subscriber {

    @IBOutlet weak var barcode: UIImageView!

    private let uuid = UUID().uuidString
    
    func receive(_ message: Message) {
        updateBarcode()
    }

    func getSubscriberId() -> String {
        return uuid
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.BarcodeType)
        
        guard let barcode = Directory.sharedInstance.getBarcode() else {
            return
        }
        
        if barcode.getState() == BarcodeState.ready {
            updateBarcode()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let _ = Broadcaster.sharedInstance.unsubscribe(self, messageKey: AppMessages.BarcodeType)
    }


    private func updateBarcode() {
        let location = FileLocationProvider().getBarcodeLocation()
        
        barcode.image = UIImage(contentsOfFile: location.path)
    }

}

