//
//  FvMapImage.swift
//  Fastaval App
//
//  Created by Peter Lind on 10/03/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import UIKit

class FvMapImage: UIImage {
    
    private let roomCoordinates = ["r20": [["x": 138, "y": 66, "width": 47, "height": 49]],
                                   "r21": [["x": 229, "y": 66, "width": 47, "height": 49]],
                                   "r22": [["x": 229, "y": 113, "width": 47, "height": 44]],
                                   "r23": [["x": 229, "y": 158, "width": 47, "height": 46]],
                                   "r19": [["x": 138, "y": 157, "width": 47, "height": 47]],
                                   "r18": [["x": 139, "y": 204, "width": 47, "height": 47]],
                                   
                                   "r7": [["x": 198, "y": 279, "width": 31, "height": 42]],
                                   "r56": [["x": 141, "y": 341, "width": 44, "height": 44]],
                                   "r16": [["x": 209, "y": 335, "width": 46, "height": 37]],
                                   "r15": [["x": 255, "y": 336, "width": 46, "height": 37]],
                                   "r8": [["x": 269, "y": 279, "width": 51, "height": 42]],
                                   "r9": [["x": 320, "y": 279, "width": 49, "height": 42]],
                                   "r10": [["x": 327, "y": 343, "width": 42, "height": 44]],
    "r11": [["x": 327, "y": 386, "width": 42, "height": 46]],
    "r77": [["x": 327, "y": 431, "width": 42, "height": 14]],
    "r12": [["x": 327, "y": 444, "width": 42, "height": 45]],
    "r13": [["x": 327, "y": 489, "width": 42, "height": 33]],
    "r14": [["x": 327, "y": 522, "width": 42, "height": 45]],
    "r54": [["x": 327, "y": 566, "width": 42, "height": 47]],
    
    "r2": [["x": 196, "y": 479, "width": 118, "height": 113]],
    "r3": [["x": 196, "y": 479, "width": 118, "height": 113]],
    "r1": [["x": 196, "y": 614, "width": 118, "height": 147], ["x": 325, "y": 684, "width": 61, "height": 121]],
    
    "r38": [["x": 196, "y": 811, "width": 118, "height": 20], ["x": 326, "y": 872, "width": 61, "height": 58]],
    
    "r55": [["x": 141, "y": 742, "width": 44, "height": 39]],
    "r5":  [["x": 141, "y": 780, "width": 44, "height": 39]],
    "r78": [["x": 141, "y": 832, "width": 44, "height": 41]],
    
    "r25": [["x": 136, "y": 912, "width": 49, "height": 39]],
    "r24": [["x": 136, "y": 951, "width": 49, "height": 39]],
    "r27": [["x": 273, "y": 931, "width": 41, "height": 44]],
    "r28": [["x": 326, "y": 991, "width": 32, "height": 24]],
    
    "r32": [["x": 521, "y": 872, "width": 51, "height": 41]],
    "r31": [["x": 521, "y": 912, "width": 51, "height": 39]],
    "r30": [["x": 521, "y": 951, "width": 51, "height": 40]],
    "r29": [["x": 538, "y": 991, "width": 34, "height": 26]],
    "r74": [["x": 585, "y": 929, "width": 40, "height": 47]],
    "r43": [["x": 712, "y": 990, "width": 32, "height": 28]],
    "r75": [["x": 735, "y": 933, "width": 28, "height": 57]],
    "r35": [["x": 735, "y": 873, "width": 38, "height": 59]],
    
    
    "r66": [["x": 530, "y": 532, "width": 37, "height": 48]],
    "r59": [["x": 530, "y": 449, "width": 37, "height": 44]],
    "r60": [["x": 530, "y": 404, "width": 37, "height": 44]],
    "r17": [["x": 530, "y": 342, "width": 37, "height": 44]],
    "r61": [["x": 584, "y": 281, "width": 39, "height": 43]],
    "r76": [["x": 656, "y": 281, "width": 37, "height": 43]],
    "r44": [["x": 693, "y": 281, "width": 62, "height": 43]],
    
    "r37": [["x": 525, "y": 204, "width": 47, "height": 46]],
    
    "r73": [["x": 572, "y": 216, "width": 20, "height": 65], ["x": 543, "y": 250, "width": 28, "height": 30]],
    "r65": [["x": 152, "y": 113, "width": 77, "height": 44]]
]
    
    func getHighlightCenter(roomId : String) -> CGPoint? {
        guard let coordinates = roomCoordinates[roomId.lowercased()] else {
            return nil
        }
        
        let firstCoordinates = coordinates[0]
        
        return CGPoint(x: firstCoordinates["x"]! + firstCoordinates["width"]! / 2, y: firstCoordinates["y"]! + firstCoordinates["height"]! / 2)
    }
    
    func highlightRoom(roomId : String) -> UIImage? {
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        guard let coordinates = roomCoordinates[roomId.lowercased()] else {
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return newImage
        }

        let context = UIGraphicsGetCurrentContext()
 
        context!.setFillColor(red: 1, green: 0.5, blue: 0.7, alpha: 0.3)

        coordinates.forEach {
            (set) in
            context!.fill(CGRect(x: set["x"]!, y: set["y"]!, width: set["width"]!, height: set["height"]!))

        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return newImage
    }
}
