//
//  ProgramEventTimeslot.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/03/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import Foundation
import RealmSwift

class ProgramEventTimeslot : Object {
    dynamic var id : Int = 0
    dynamic var roomId : String? = nil

    dynamic var event : ProgramEvent?
    dynamic var timeslot : ProgramTimeslot?
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
