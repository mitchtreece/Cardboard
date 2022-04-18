//
//  FadeCardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

internal class FadeCardAnimator: CardAnimator {
    
    override func setup(ctx: CardAnimator.Context) {
        
        ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 0 : 1
        ctx.cardView.alpha = (ctx.animation == .presentation) ? 0 : 1
        
    }
    
    override func animate(ctx: CardAnimator.Context) {
        
        ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 1 : 0
        ctx.cardView.alpha = (ctx.animation == .presentation) ? 1 : 0
        
    }
    
}
