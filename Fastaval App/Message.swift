//
//  Message.swift
//  Fastaval App
//
//  Created by Peter Lind on 05/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

typealias MessageKey = String

protocol Message {
    func messageKey() -> MessageKey
}