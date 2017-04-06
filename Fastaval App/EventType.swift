//
//  EventType.swift
//  Fastaval App
//
//  Created by Peter Lind on 13/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum EventType {
    case roleplay, boardgame, live, figure, workshop, food, other, magic, junior, diy
    
    static func toImageId(_ original: EventType) -> String? {
        switch(original) {
        case .workshop: return "workshop"
        case .food: return "food"
        case .figure: return "figur"
        case .roleplay: return "rolle"
        case .boardgame: return "braet"
        case .junior: return "child"
        case .other: return "stars"
        case .live: return "spy"
        case .magic: return "magic"
        case .diy: return "work"
        }
    }
    
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
        case .junior: return "junior"
        case .diy: return "gds"
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
        case "junior": return .junior
        case "gds": return .diy
        default:
            return .other
        }
    }
}
