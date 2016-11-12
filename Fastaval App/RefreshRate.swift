//
//  RefreshRate.swift
//  Fastaval App
//
//  Created by Peter Lind on 14/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum RefreshRate {
    case fiveMins, fifteenMins, oneHour, oneDay, manual
    
    static func secondsToCode(_ seconds : Int) -> RefreshRate {
        switch seconds {
        case 0:
            return RefreshRate.manual
        case 5 * 60:
            return RefreshRate.fiveMins
        case 15 * 60:
            return RefreshRate.fifteenMins
        case 60 * 60:
            return RefreshRate.oneHour
        case 24 * 60 * 60:
            return RefreshRate.oneDay
        default:
            return RefreshRate.fifteenMins
        }
    }
    
    static func parseString(_ input : String) -> RefreshRate {
        switch input.lowercased() {
        case "manual", "manuelt":
            return RefreshRate.manual
        case "5 minutes", "5. minut":
            return RefreshRate.fiveMins
        case "15 minutes", "15. minut":
            return RefreshRate.fifteenMins
        case "hourly", "hver time":
            return RefreshRate.oneHour
        case "daily", "dagligt":
            return RefreshRate.oneDay
        default:
            return RefreshRate.fifteenMins
        }
    }
    
    func convertToSeconds() -> Int {
        switch(self) {
        case .fiveMins:
            return 5 * 60
        
        case .fifteenMins:
            return 15 * 60
        
        case .oneHour:
            return 60 * 60
            
        case .oneDay:
            return 24 * 60 * 60
            
        case .manual:
            return 0
        }
    }
    
    func toString() -> String {
        switch self {
        case .manual:
            return "Manual"
        case .fiveMins:
            return "5 minutes"
        case .fifteenMins:
            return "15 minutes"
        case .oneHour:
            return "Hourly"
        case .oneDay:
            return "Daily"
        }
    }
}
