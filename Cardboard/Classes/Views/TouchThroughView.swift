//
//  TouchThroughView.swift
//  Cardboard
//
//  Created by Mitch Treece on 5/17/22.
//

import UIKit

internal class TouchThroughView: UIView {
        
    override func hitTest(_ point: CGPoint,
                          with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(
            point,
            with: event
        )
        
        return (view == self) ? nil : view
        
    }
    
}
