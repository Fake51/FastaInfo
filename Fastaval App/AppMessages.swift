//
//  AppMessages.swift
//  Fastaval App
//
//  Created by Peter Lind on 09/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum AppMessages : Message {
    case user, news, program, map
    
    static let UserType = "user"
    static let NewsType = "news"
    static let ProgramType = "program"
    static let MapType = "map"
    
    
    func messageKey() -> MessageKey {
        switch self {
        case .user: return AppMessages.UserType
        case .news: return AppMessages.NewsType
        case .program: return AppMessages.ProgramType
        case .map: return AppMessages.MapType
            
        }
    }
    
}
