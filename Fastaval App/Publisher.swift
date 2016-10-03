//
//  Publisher.swift
//  Fastaval App
//
//  Created by Peter Lind on 05/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

protocol Publisher {
    func subscribe(_ subscriber: Subscriber, messageKey: MessageKey, subScriberId: String) -> Publisher
    func unsubscribe(_ subscriber: Subscriber, messageKey: MessageKey, subScriberId: String) -> Publisher
}
