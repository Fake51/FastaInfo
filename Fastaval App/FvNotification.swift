//
//  FvNotification.swift
//  Fastaval App
//
//  Created by Peter Lind on 04/04/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import Foundation
import RealmSwift

class FvNotification : Object {
    dynamic var title = ""
    dynamic var body = ""
    dynamic var time : Date?
}
