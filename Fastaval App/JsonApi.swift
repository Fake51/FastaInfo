//
//  JsonApi.swift
//  Fastaval App
//
//  Created by Peter Lind on 25/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import SwiftyJSON

protocol JsonApi {
    func getParticipantData(_ callback: @escaping (JSON?) -> Void, userId: Int, password: String)
}
