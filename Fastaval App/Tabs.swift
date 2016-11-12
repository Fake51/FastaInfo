//
//  Tabs.swift
//  Fastaval App
//
//  Created by Peter Lind on 10/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum Tabs : Int {
    case home = 0
    case map = 3
    case barcode = 2
    case program = 1
    case settings = 4
    
    static func getTranslationKey(_ input : Tabs) -> String {
        switch input {
        case .home: return "Home"
        case .program: return "Program"
        case .barcode: return "Barcode"
        case .map: return "Map"
        case .settings: return "Settings"
        }
    }
}
