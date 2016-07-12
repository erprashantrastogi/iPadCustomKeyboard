//
//  TouchForwardingView.swift
//  ELDeveloperKeyboard
//
//  Created by Kari Kraam on 2016-04-25.
//  Copyright (c) 2016 Kari Kraam. All rights reserved.
//

import Foundation
import UIKit

/**
    The methods declared in the TouchForwardingViewDelegate protocol allow the adopting delegate to respond to override the behaviour of hitTest:withEvent: for the TouchForwardingView class.
*/
protocol TouchForwardingViewDelegate: class {
    /**
        Allows the delegate to override the behaviour of hitTest:withEvent: for this view.
     
        - parameter point: The CGPoint that was touched.
        - parameter event: The touch event.
        - parameter superResult: The UIView returned by the call to super.
    
        - returns: A UIView that the delegate decides should receive the touch event.
    */
    func viewForHitTestWithPoint(point: CGPoint, event: UIEvent?, superResult: UIView?) -> UIView?
}

class TouchForwardingView: UIView {
    
    // MARK: Properties
    
    weak var delegate: TouchForwardingViewDelegate?
    
    // MARK: Constructors
    
    init(frame: CGRect, delegate: TouchForwardingViewDelegate?) {
        self.delegate = delegate
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overridden methods
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, withEvent: event)
        if let unwrappedDelegate = delegate {
            return unwrappedDelegate.viewForHitTestWithPoint(point, event: event, superResult: result)
        }
        return result
    }
}