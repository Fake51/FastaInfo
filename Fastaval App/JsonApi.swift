//
//  JsonApi.swift
//  Fastaval App
//
//  Created by Peter Lind on 25/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import SwiftyJSON

protocol JsonApi {
    func getParticipantData(userId: Int, password: String, _ callback: @escaping (JSON?) -> Void)
    func getProgramData(_ callback: @escaping (JSON?) -> Void)
    func retrieveMap(location: URL, completedHandler: @escaping () -> Void)
    func isUpdatedMapAvailable(lastUpdate: Date, completedHandler: @escaping (_ updateAvailable: Bool) -> ()) -> Void
}
