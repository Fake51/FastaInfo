//
//  News.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

class News : Stateful {

    fileprivate var infosysApi : JsonApi

    fileprivate var state = NewsState.notReady
    
    init(infosysApi : JsonApi) {
        self.infosysApi = infosysApi
    }
    
    func getState() -> NewsState {
        return state
    }
}
