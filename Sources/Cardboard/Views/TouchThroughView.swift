//
//  TouchThroughView.swift
//  Cardboard
//
//  Created by Mitch Treece on 5/19/22.
//

import UIKit

internal class TouchThroughView: UIView {
    
    var isTouchThroughEnabled: Bool = true
    
    override func hitTest(_ point: CGPoint,
                          with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(
            point,
            with: event
        )
        
        guard self.isTouchThroughEnabled else { return view }
        
        return (view == self) ? nil : view
        
    }
    
}
