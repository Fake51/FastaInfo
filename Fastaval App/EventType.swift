//
//  EventType.swift
//  Fastaval App
//
//  Created by Peter Lind on 13/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum EventType {
    case roleplay, boardgame, live, figure, workshop, food, other, magic
    
    static func translate(_ original: EventType) -> String {
        switch(original) {
        case .roleplay: return "rolle"
        case .boardgame: return "braet"
        case .live: return "live"
        case .figure: return "figur"
        case .workshop: return "workshop"
        case .food: return "mad"
        case .magic: return "magic"
        case .other: return "andet"
        }
    }
    
    static func translate(_ original: String) -> EventType {
        switch(original) {
        case "rolle": return .roleplay
        case "braet": return .boardgame
        case "live": return .live
        case "figur": return .figure
        case "workshop": return .workshop
        case "magic": return .magic
        case "mad": return .food
        default:
            return .other
        }
    }
}
