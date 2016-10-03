//
//  Participant.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class Participant : Subscriber, Stateful {
    
    fileprivate var state = ParticipantState.notReady

    fileprivate var infosysApi : JsonApi

    fileprivate var uuid = UUID().uuidString
    
    init(infosysApi: JsonApi) {
        self.infosysApi = infosysApi
    }
    
    func receive(_ message: Message) {
        
        
    }

    func getState() -> ParticipantState {
        return state
    }
    
    func getSubscriberId() -> String {
        return uuid
    }

}
