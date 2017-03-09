//
//  Date.swift
//  Fastaval App
//
//  Created by Peter Lind on 09/12/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import Foundation

extension Date {
    func toFvDate() -> Date {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"

        let dateId = dayFormatter.string(from: self.addingTimeInterval(TimeInterval(-60*60*4)))
        return dayFormatter.date(from: dateId)!

    }
    
    func toFvDateString() -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        return dayFormatter.string(from: self.addingTimeInterval(TimeInterval(-60*60*4)))
    }

}
