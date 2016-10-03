//
//  Subscribing.swift
//  Fastaval App
//
//  Created by Peter Lind on 05/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

protocol Subscriber {
    func receive(_ message: Message)
    func getSubscriberId() -> String
}
