//
//  TouchForwardingView.swift
//  Cardboard
//
//  Created by Mitch Treece on 5/17/22.
//

import UIKit

internal class TouchForwardingView: UIView {
    
    weak var touchForwardedView: UIView?
        
    override func hitTest(_ point: CGPoint,
                          with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(
            point,
            with: event
        )
 
        if let forwardedView = self.touchForwardedView, view == self {
            
            return forwardedView.hitTest(
                point,
                with: event
            )
            
        }
        
        return view
        
    }
    
}
