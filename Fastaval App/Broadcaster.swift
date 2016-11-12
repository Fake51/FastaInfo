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
    
    private var subscribers = Dictionary<MessageKey, Dictionary<String, Subscriber>>()
    

    private init() {
    }

    func subscribe(_ subscriber: Subscriber, messageKey: MessageKey) -> Publisher {
        // implement stuff
        
        if subscribers[messageKey] == nil {
           subscribers[messageKey] = Dictionary<String, Subscriber>()
        }
        
        subscribers[messageKey]![subscriber.getSubscriberId()] = subscriber

        return self
    }
    
    func unsubscribe(_ subscriber: Subscriber, messageKey: MessageKey) -> Publisher {
        // stuff
        
        if let messageSubscribers = subscribers[messageKey] {
            
            if messageSubscribers[subscriber.getSubscriberId()] != nil {
                subscribers[messageKey]![subscriber.getSubscriberId()] = nil

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
