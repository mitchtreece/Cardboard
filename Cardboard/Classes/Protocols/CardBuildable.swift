//
//  CardBuildable.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

internal protocol CardBuildable {
    
    /// The card's anchor; _defaults to bottom_.
    var anchor: Card.Anchor { get set }
    
    /// The card's animator; _defaults to slide_.
    var animator: CardAnimator { get set }
    
    /// The card's duration; _defaults to none_.
    var duration: Card.Duration { get set }
    
    /// The card's status bar style; _defaults to default_.
    var statusBar: UIStatusBarStyle { get set }
    
    /// Flag indicating if the card should hide the home indicator upon presentation; _defaults to false_.
    var hidesHomeIndicator: Bool { get set }
    
    /// Flag indicating if tapping the content overlay should dismiss the card; _defaults to true_.
    var isContentOverlayTapToDismissEnabled: Bool { get set }
    
    /// Flag indicating if the card is dismissable by swiping it away; _defaults to true_.
    var isSwipeToDismissEnabled: Bool { get set }
    
    /// The card's content overlay style; _defaults to color(black, alpha: 0.5)_.
    var contentOverlay: Card.BackgroundStyle { get set }
    
    /// The card's background style; _defaults to color(white)_.
    var background: Card.BackgroundStyle { get set }
    
    /// The card's edge styling; _defaults to default_.
    var edges: CardEdgeStyle { get set }
    
    /// The card's corner styling; _defaults to default_.
    var corners: CardCornerStyle { get set }
    
    /// The card's shadow styling; _defaults to default(bottom)_.
    var shadow: CardShadowStyle { get set }
    
    // var action: (()->())? { get set }
    
    /// The action to call when a card is about to be presented.
    var willPresentAction: (()->())? { get set }
    
    /// The action to call when a card has finished being presented.
    var didPresentAction: (()->())? { get set }
    
    /// The action to call when a card is about to be dismissed.
    var willDismissAction: ((Card.DismissalReason)->())? { get set }
    
    /// The action to call when a card has finished being dismissed.
    var didDismissAction: ((Card.DismissalReason)->())? { get set }
    
}
