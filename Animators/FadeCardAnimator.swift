//
//  FadeCardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

internal class FadeCardAnimator: CardAnimator {

    init() {
        
        super.init(setup: { ctx in
                       
            ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 0 : 1
            ctx.cardView.alpha = (ctx.animation == .presentation) ? 0 : 1
            
        }, animations: { ctx in
            
            ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 1 : 0
            ctx.cardView.alpha = (ctx.animation == .presentation) ? 1 : 0
            
        }, completion: nil)
                        
    }
    
}
