//
//  String.swift
//  Fastaval App
//
//  Created by Peter Lind on 29/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import Foundation

extension String {
    func localized(lang:String) -> String {
        
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            return self
        }
        
        let bundle = Bundle(path: path)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
