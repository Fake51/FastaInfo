//
//  Directory.swift
//  Fastaval App
//
//  Created by Peter Lind on 02/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import Foundation

class Directory {
    static let sharedInstance = Directory()

    fileprivate var participant : Participant?

    fileprivate var news : News?
    
    fileprivate init() {
        
    }
    
    func setParticipant(_ participant : Participant) -> Directory {
        self.participant = participant
        
        return self
    }
    
    func setNews(_ news : News) -> Directory {
        self.news = news
        
        return self
    }

    func getParticipant() -> Participant? {
        if let p = self.participant {
            return p
        }
        
        return nil
    }

    func getNews() -> News? {
        if let n = self.news {
            return n
        }
        
        return nil
    }

}
