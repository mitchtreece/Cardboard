//
//  CustomCardAnimator.swift
//  Demo
//
//  Created by Mitch Treece on 4/14/23.
//

import UIKit
import Cardboard

class CustomCardAnimator: CardAnimator {
    
    override init() {
        
        super.init()
        
        self.duration = 0.8
        
        self.timingProvider = UISpringTimingParameters(
            dampingRatio: 0.7,
            initialVelocity: .init(dx: 0.3, dy: 0.3)
        )
        
    }
    
    override func setup(ctx: CardAnimator.Context) {

        ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 0 : 1
        ctx.cardView.alpha = (ctx.animation == .presentation) ? 0 : 1
        
    }
    
    override func animate(ctx: CardAnimator.Context) {
        
        ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 1 : 0
        ctx.cardView.alpha = (ctx.animation == .presentation) ? 1 : 0

        ctx.sourceView.roundCorners(
            .allCorners,
            radius: (ctx.animation == .presentation) ? 24 : 0,
            curve: .continuous
        )
        
        ctx.sourceView.transform = (ctx.animation == .presentation) ?
            .init(scaleX: 0.88, y: 0.88) :
            .identity
        
    }
    
    override func cleanup(ctx: CardAnimator.Context) {
        //
    }
    
}
