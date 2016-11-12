//
//  InfosysApi.swift
//  FV tab
//
//  Created by Fake on 09/11/15.
//  Copyright © 2015 Fastaval. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class InfosysApi: JsonApi {

    fileprivate let mapUrl = "https://infosys.fastaval.dk/img/location.svg"
    
    fileprivate let userUrl = "https://infosys2016.fastaval.dk/api/v3/user/:id:/?pass=:pass:"
    
    fileprivate let programUrl = "https://infosys2016.fastaval.dk/api/app/v3/activities/*"
   
    // get activities list
    func getProgramData(_ callback: @escaping (JSON?) -> Void) {
        Just.get(programUrl, params: [:]) { (r) in
            if (!r.ok) {
                callback(nil)

            } else {
                callback(JSON.parse(r.text!))
                
            }
            
        }
    }

    
    // request and parse user data
    func getParticipantData(userId: Int, password: String, _ callback: @escaping (JSON?) -> Void) {
        let url =  userUrl.replacingOccurrences(of: ":id:", with: String(userId)).replacingOccurrences(of: ":pass:", with: password)

        Just.get(url, params:[:]) { (r) in
            if !r.ok {
                callback(nil)
                
            } else {
                callback(JSON.parse(r.text!))
            }
        }
        
    }
    
    func retrieveMap(location: URL, completedHandler: @escaping () -> Void) {
        Just.get(mapUrl, params:[:]) { (r) in
            if r.ok {
                try! r.content?.write(to: location)

                completedHandler()
            }
        }
    }
    
    func isUpdatedMapAvailable(lastUpdate: Date, completedHandler: @escaping (_ updateAvailable: Bool) -> Void) {
        Just.head(mapUrl) {(r) in
            guard let dateString = r.headers["last-modified"] else {
                completedHandler(false)
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, dd LLL yyyy HH:mm:ss zzz"
            
            guard let modified = dateFormatter.date(from: dateString) else {
                completedHandler(false)
                return
            }
            
            completedHandler(modified.compare(lastUpdate) == ComparisonResult.orderedDescending)
        }
    }

}
