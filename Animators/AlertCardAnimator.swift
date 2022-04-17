//
//  AlertCardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

internal class AlertCardAnimator: CardAnimator {

    init() {
        
        super.init(setup: { ctx in
                        
            ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 0 : 1
            ctx.cardView.alpha = (ctx.animation == .presentation) ? 0 : 1
            
            ctx.cardView.transform = (ctx.animation == .presentation) ?
                .init(translationX: 0, y: 30).scaledBy(x: 0.9, y: 0.9) :
                .identity

        }, animations: { ctx in
            
            ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 1 : 0
            ctx.cardView.alpha = (ctx.animation == .presentation) ? 1 : 0
            
            ctx.cardView.transform = (ctx.animation == .presentation) ?
                .identity :
                .init(translationX: 0, y: 30).scaledBy(x: 0.9, y: 0.9)
 
        }, completion: nil)
                        
    }
    
}
