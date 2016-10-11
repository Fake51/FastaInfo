//
//  FileLocationProvider.swift
//  Fastaval App
//
//  Created by Peter Lind on 10/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class FileLocationProvider {
    fileprivate let mapFilename = "location.svg"
    
    func getMapLocation () -> URL {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // create a name for your image
        return documentsDirectoryURL.appendingPathComponent(mapFilename)

    }
}
