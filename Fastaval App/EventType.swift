//
//  EventType.swift
//  Fastaval App
//
//  Created by Peter Lind on 13/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum EventType {
    case roleplay, boardgame, live, figure, workshop, food, other
    
    static func translate(_ original: String) -> EventType {
        switch(original) {
        default:
            return .other
        }
    }
}
