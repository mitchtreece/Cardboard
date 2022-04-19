//
//  CardBuilder.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

public struct CardBuilder: CardStyleProvider, CardActionProvider {
    
    internal var contentView: CardContentView
    
    public var anchor: Card.Anchor = .bottom
    public var animator: CardAnimator = SlideCardAnimator()
    public var duration: Card.Duration = .none
    public var statusBar: UIStatusBarStyle = .default
    public var hidesHomeIndicator: Bool = false
    public var isContentOverlayTapToDismissEnabled: Bool = true
    public var isSwipeToDismissEnabled: Bool = true
    
    public var contentOverlay: Card.BackgroundStyle = .color(.black.withAlphaComponent(0.5))
    public var background: Card.BackgroundStyle = .color(.white)
    public var edges: CardEdgeStyle = .default
    public var corners: CardCornerStyle = .default
    public var shadow: CardShadowStyle = .default(for: .bottom)
    
    // public var action: (()->())?
    public var willPresentAction: (()->())?
    public var didPresentAction: (()->())?
    public var willDismissAction: ((Card.DismissalReason)->())?
    public var didDismissAction: ((Card.DismissalReason)->())?
    
    internal init(contentView: CardContentView) {
        self.contentView = contentView
    }
    
}
