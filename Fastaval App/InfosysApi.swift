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

    private let mapUrl = "https://infosys.fastaval.dk/img/map2017.png"
    
    private let userUrl = "https://infosys.fastaval.dk/api/v3/user/:id:/?pass=:pass:"
    
    private let programUrl = "https://infosys.fastaval.dk/api/app/v3/activities/*"
   
    private let barcodeUrl = "https://infosys.fastaval.dk/participant/ean8/:id:"
    
    // get activities list
    func getProgramData(_ callback: @escaping (JSON?) -> Void) {
        Just.get(programUrl, params: [:]) { (r) in
            if (!r.ok) {
                callback(nil)

            } else {
                callback(JSON(parseJSON: r.text!))
                
            }
            
        }
    }

    
    // request and parse user data
    func getParticipantData(userId: Int, password: String, _ callback: @escaping (SwiftyJSON.JSON?) -> Void) {
        let url =  userUrl.replacingOccurrences(of: ":id:", with: String(userId)).replacingOccurrences(of: ":pass:", with: password)

        Just.get(url, params:[:]) { (r) in
            if !r.ok {
                callback(nil)
                
            } else {
                callback(SwiftyJSON.JSON(parseJSON: r.text!))
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

    func retrieveBarcode(userId: Int, location: URL, completedHandler: @escaping () -> Void) {
        Just.get(barcodeUrl.replacingOccurrences(of: ":id", with: String(userId))) { (r) in
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
