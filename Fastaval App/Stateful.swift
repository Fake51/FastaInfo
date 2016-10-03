//
//  Stateful.swift
//  Fastaval App
//
//  Created by Peter Lind on 02/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

protocol Stateful {
    associatedtype State
    
    func getState() -> State
}