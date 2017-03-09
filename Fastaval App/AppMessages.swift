//
//  AppMessages.swift
//  Fastaval App
//
//  Created by Peter Lind on 09/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

enum AppMessages : Message {
    case user, news, program, map, settings, remoteSync, barcode
    
    static let UserType = "user"
    static let NewsType = "news"
    static let ProgramType = "program"
    static let MapType = "map"
    static let SettingsType = "settings"
    static let RemoteSyncType = "remoteSync"
    static let BarcodeType = "barcode"
    
    
    func messageKey() -> MessageKey {
        switch self {
        case .user: return AppMessages.UserType
        case .news: return AppMessages.NewsType
        case .program: return AppMessages.ProgramType
        case .map: return AppMessages.MapType
        case .settings: return AppMessages.SettingsType
        case .remoteSync: return AppMessages.RemoteSyncType
        case .barcode: return AppMessages.BarcodeType
        }
    }
    
}
