//
//  Image.swift
//  Fastaval App
//
//  Created by Peter Lind on 27/03/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import UIKit

extension UIImage {
    func imageRotatedByDegrees(deg degrees: CGFloat) -> UIImage {

        let radians = degrees * CGFloat(M_PI / 180)
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        dummyView.transform = CGAffineTransform(rotationAngle: radians)

        UIGraphicsBeginImageContext(dummyView.frame.size)
        
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!

        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: dummyView.frame.size.width / 2, y: dummyView.frame.size.height / 2)

        //Rotate the image context
        bitmap.rotate(by: radians)
        
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
        
        bitmap.draw(self.cgImage!, in: CGRect(origin: origin, size: size))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
