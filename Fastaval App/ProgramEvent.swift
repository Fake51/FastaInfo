//
//  ProgramEvent.swift
//  Fastaval App
//
//  Created by Peter Lind on 13/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramEvent : Object {
    dynamic var id = 0
    dynamic var titleEn : String? = nil
    dynamic var titleDa : String? = nil
    dynamic var descriptionEn : String? = nil
    dynamic var descriptionDa : String? = nil
    dynamic var author : String? = nil

    dynamic var type : String? = nil
    let timeSlots =  List<ProgramTimeslot>()
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
