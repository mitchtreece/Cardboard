//
//  DefaultCardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

internal class DefaultCardAnimator: CardAnimator {
    
    override func setup(ctx: CardAnimator.Context) {
        
        ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 0 : 1

        ctx.cardView.transform = (ctx.animation == .presentation) ?
            hiddenCardTransform(ctx) :
            .identity
        
    }
    
    override func animate(ctx: CardAnimator.Context) {
        
        ctx.contentOverlayView.alpha = (ctx.animation == .presentation) ? 1 : 0
        
        ctx.cardView.transform = (ctx.animation == .presentation) ?
            .identity :
            hiddenCardTransform(ctx)
        
    }
    
    private func hiddenCardTransform(_ ctx: Context) -> CGAffineTransform {
        
        var translation: CGPoint = .zero

        switch ctx.anchor {
        case .top:

            translation.y = -ctx.cardView.bounds.height
            translation.y -= ctx.insets.top

        case .left:

            translation.x = -ctx.cardView.bounds.width
            translation.x -= ctx.insets.left

        case .bottom:

            translation.y = ctx.cardView.bounds.height
            translation.y += ctx.insets.bottom

        case .right:

            translation.x = ctx.cardView.bounds.width
            translation.x += ctx.insets.right
            
        default: break
        }

        return CGAffineTransform(
            translationX: translation.x,
            y: translation.y
        )
        
    }
}
