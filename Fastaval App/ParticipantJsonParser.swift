//
//  ParticipantJsonParser.swift
//  Fastaval App
//
//  Created by Peter Lind on 16/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import SwiftyJSON

class ParticipantJsonParser {
    func parse(_ json : JSON) -> ParticipantData {
        let storage = ParticipantData()

        storage.id = Int(json["id"].string!)!
        storage.name = json["name"].string!
        storage.barcodeId = Int(json["barcode"].string!)!
        storage.category = json["category"].string!
        storage.checkedIn = json["checked_in"].number! != 0
        
        return storage
    }
}
