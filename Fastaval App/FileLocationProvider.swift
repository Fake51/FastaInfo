//
//  FileLocationProvider.swift
//  Fastaval App
//
//  Created by Peter Lind on 10/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class FileLocationProvider : DirectoryItem {
    private let mapFilename     = "location.svg"
    private let barcodeFilename = "barcode.png"
    
    func getMapLocation () -> URL {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // create a name for your image
        return documentsDirectoryURL.appendingPathComponent(mapFilename)

    }
    
    func getBarcodeLocation () -> URL {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // create a name for your image
        return documentsDirectoryURL.appendingPathComponent(barcodeFilename)

    }

    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.fileLocationProvider
    }
}
