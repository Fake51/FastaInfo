//
//  StateStore.swift
//  Fastaval App
//
//  Created by Peter Lind on 04/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import Foundation

class Broadcaster : Publisher {
    
    static let sharedInstance = Broadcaster()
    
    fileprivate var subscribers = Dictionary<MessageKey, Dictionary<String, Subscriber>>()
    

    fileprivate init() {
        /*
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "testIt:", userInfo: nil, repeats: false)
*/
    }

    func subscribe(_ subscriber: Subscriber, messageKey: MessageKey, subScriberId: String) -> Publisher {
        // implement stuff

        if subscribers[messageKey] == nil {
           subscribers[messageKey] = Dictionary<String, Subscriber>()
        }
        
        subscribers[messageKey]![subScriberId] = subscriber

        return self
    }
    
    func unsubscribe(_ subscriber: Subscriber, messageKey: MessageKey, subScriberId: String) -> Publisher {
        // stuff
        
        if let messageSubscribers = subscribers[messageKey] {
            
            if messageSubscribers[subScriberId] != nil {
                subscribers[messageKey]![subScriberId] = nil

            }
        }
        
        return self
    }
    
    func publish(message: Message) {
        if let listeners = subscribers[message.messageKey()] {
            for (_, subscriber) in listeners {
                
                let send : ()->() = {
                    subscriber.receive(message)
                }
                
                DispatchQueue.main.async(execute: send)
                
            }
        }
    }


    /*
    dynamic func testIt(timer: NSTimer!) {
        do {
            try loginState.transition(LoginStatus.LoggedIn)
            
        } catch  {
        }

        self.publish(AppMessages.User)
        self.publish(AppMessages.News)
    }
*/
}
