//
//  UIImageFromCALayer.swift
//  ELDeveloperKeyboard
//
//  Created by Kari Kraam on 2016-04-25.
//  Copyright (c) 2016 Kari Kraam. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension CALayer {
    /**
        Creates a UIImage from a CALayer.
     
        - returns: A UIImage that appears identical to the CALayer.
    */
    func UIImageFromCALayer() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
        renderInContext(UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
}