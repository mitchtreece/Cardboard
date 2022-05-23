//
//  CardBuilder.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

/// A builder object that provides various style & action attributes used to create a card.
public struct CardBuilder: CardBuildable {
            
    public var anchor: Card.Anchor = .bottom
    public var animator: CardAnimator = DefaultCardAnimator()
    public var duration: Card.Duration = .none
    public var statusBar: UIStatusBarStyle = .default
    public var contentOverlay: Card.BackgroundStyle = .none
    public var background: Card.BackgroundStyle = .none
    public var edges: CardEdgeStyle = .none
    public var corners: CardCornerStyle = .none
    public var shadow: CardShadowStyle = .none
    public var hidesHomeIndicator: Bool = false
    public var isSwipeToDismissEnabled: Bool = false
    public var isContentOverlayTapToDismissEnabled: Bool = false
    public var isContentOverlayTouchThroughEnabled: Bool = false
    public var dismissesCurrentCardsInContext: Bool = true
        
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
        self.contentOverlay = buildable.contentOverlay
        self.background = buildable.background
        self.edges = buildable.edges
        self.corners = buildable.corners
        self.shadow = buildable.shadow
        self.hidesHomeIndicator = buildable.hidesHomeIndicator
        self.isSwipeToDismissEnabled = buildable.isSwipeToDismissEnabled
        self.isContentOverlayTapToDismissEnabled = buildable.isContentOverlayTapToDismissEnabled
        self.isContentOverlayTouchThroughEnabled = buildable.isContentOverlayTouchThroughEnabled
        self.dismissesCurrentCardsInContext = buildable.dismissesCurrentCardsInContext
        
        self.willPresentAction = buildable.willPresentAction
        self.didPresentAction = buildable.didPresentAction
        self.willDismissAction = buildable.willDismissAction
        self.didDismissAction = buildable.didDismissAction
        
    }

}
