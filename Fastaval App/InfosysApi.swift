//
//  InfosysApi.swift
//  FV tab
//
//  Created by Fake on 09/11/15.
//  Copyright © 2015 Fastaval. All rights reserved.
//

import UIKit
import SwiftyJSON

class InfosysApi: JsonApi {

    // return activities list
    /*
    func getActivities(callback: ([String: ProgramDay]) -> Void) -> Void {
        let url = NSURL(string: "http://infosys-test.fastaval.dk/api/app/v2/activities/*")

        if programDays.count > 0 {
            callback(programDays)
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
            
                let json = JSON(data: data!)
            
                callback(self.makeActivityData(json))
            
            }
            
            })
        task.resume()
    }

    */ */

    // request and parse user data
    func getParticipantData(_ callback: @escaping (JSON?) -> Void, userId: Int, password: String) {
        let url = URL(string:"http://infosys-test.fastaval.dk/api/v3/user/\(userId)?pass=\(password)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data: Data?, response: URLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    
                    callback(JSON(data: data!))
                    
                } else {
                    callback(nil)
            }
                
            } as! (Data?, URLResponse?, Error?) -> Void
        )
        
        task.resume()
    }
/*
    func makeUser(json: JSON) -> FvUser? {
        var user: FvUser

        if let userId = Int(json["id"].string!) {
            user = FvUser()
            user.id = userId
            user.name = json["name"].string!
            
            return user
        }
        
        return nil
    }
    
    func makeActivityData(json: JSON) -> [String: ProgramDay] {
        var days = [String: ProgramDay]()
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeslotFormatter = NSDateFormatter()
        timeslotFormatter.dateFormat = "HH:mm"
        
        for (_, activity):(String, JSON) in json {
            for (key, activityProp):(String, JSON) in activity {
                if key == "afviklinger" {
                    for (_, schedule):(String, JSON) in activityProp {
                        let timestamp: NSNumber? = schedule["start"].number
                        let date = NSDate(timeIntervalSince1970: NSTimeInterval(timestamp!))
                        
                        let dateString = dayFormatter.stringFromDate(date)
                        
                        if days[dateString] == nil {
                            days[dateString] = ProgramDay(date: dateString)
                        }
                        
                        let day = days[dateString]!
                        
                        let slotString = timeslotFormatter.stringFromDate(date)
                        
                        let slot = day.getSlotByTime(slotString)
                        
                        slot.addEvent(ProgramEvent(type: activity["type"].string!, name: activity["title_en"].string!))
                    }
                }
            }
        }
        
        programDays = days
        
        return programDays
    }


    class var SharedInstance : InfosysApi {
        struct Singleton {
            static let instance = InfosysApi()
        }
        
        return Singleton.instance
    }
 */
}
