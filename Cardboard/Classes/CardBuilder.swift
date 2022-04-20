//
//  CardBuilder.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

/// A builder object that provides various
/// style & action attributes used to
/// create a card.
public struct CardBuilder: CardBuildable {
    
    // These are documented via `CardBuildable`.
        
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
    
    internal init() {
        //
    }
    
    internal init(buildable: CardBuildable) {
        
        self.anchor = buildable.anchor
        self.animator = buildable.animator
        self.duration = buildable.duration
        self.statusBar = buildable.statusBar
        self.hidesHomeIndicator = buildable.hidesHomeIndicator
        self.isContentOverlayTapToDismissEnabled = buildable.isContentOverlayTapToDismissEnabled
        self.isSwipeToDismissEnabled = buildable.isSwipeToDismissEnabled
        
        self.contentOverlay = buildable.contentOverlay
        self.background = buildable.background
        self.edges = buildable.edges
        self.corners = buildable.corners
        self.shadow = buildable.shadow
        
        // self.action = buildable.action
        self.willPresentAction = buildable.willPresentAction
        self.didPresentAction = buildable.didPresentAction
        self.willDismissAction = buildable.willDismissAction
        self.didDismissAction = buildable.didDismissAction
        
    }

}
