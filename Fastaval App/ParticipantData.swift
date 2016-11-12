//
//  ParticipantData.swift
//  Fastaval App
//
//  Created by Peter Lind on 16/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ParticipantData : Object {
    dynamic var id = 0
    dynamic var password = ""
    
    dynamic var name : String? = nil
    
    dynamic var checkedIn = false
    
    dynamic var category : String? = nil
    
    dynamic var barcodeId = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
