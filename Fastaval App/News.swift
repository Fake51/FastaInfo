//
//  News.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

class News : Stateful, RemoteDependency, DirectoryItem {

    private let infosysApi : JsonApi

    private var state = NewsState.notReady
    
    private let settings : AppSettings
    
    init(infosysApi : JsonApi, settings: AppSettings) {
        self.infosysApi = infosysApi
        self.settings = settings
    }
    
    func getState() -> NewsState {
        return state
    }
    
    func initialize() {
        
    }
    
    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.news
    }
}
