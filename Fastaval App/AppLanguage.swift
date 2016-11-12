//
//  AppLanguage.swift
//  Fastaval App
//
//  Created by Peter Lind on 14/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum AppLanguage {
    case english, danish
    
    func toString() -> String {
        switch self {
        case .danish: return "da"
        case .english: return "en"
        }
    }
    
    static func parseString(_ input : String) -> AppLanguage {
        switch input {
        case "da", "Dansk":
            return .danish
            
        case "en", "English":
            return .english
            
        default:
            return .english
        }
    }
}
