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
    
    /// The card's animator; _defaults to default (slide)_.
    var animator: CardAnimator { get set }
    
    /// The card's duration; _defaults to none_.
    var duration: Card.Duration { get set }
    
    /// The card's status bar style; _defaults to default_.
    var statusBar: UIStatusBarStyle { get set }
    
    /// The card's content overlay style; _defaults to none_.
    var contentOverlay: Card.BackgroundStyle { get set }
    
    /// The card's background style; _defaults to none_.
    var background: Card.BackgroundStyle { get set }
    
    /// The card's edge configuration; _defaults to none_.
    var edges: CardEdges { get set }
    
    /// The card's size configuration; _defaults to default_.
    var size: CardSize { get set }
    
    /// The card's corner configuration; _defaults to none_.
    var corners: CardCorners { get set }
    
    /// The card's shadow configuration; _defaults to none_.
    var shadow: CardShadow { get set }
    
    /// Flag indicating if the card should hide the home indicator upon presentation; _defaults to false_.
    var hidesHomeIndicator: Bool { get set }
    
    /// Flag indicating if the card is dismissable by swiping it away; _defaults to false_.
    var isSwipeToDismissEnabled: Bool { get set }
    
    /// Flag indicating if tapping the content overlay should dismiss the card; _defaults to false_.
    var isContentOverlayTapToDismissEnabled: Bool { get set }
    
    /// Flag indicating if card presentation should dismiss existing cards in this context; _defaults to true.
    ///
    /// If this flag is `false`, attempting to present multiple cards from the same view controller will result
    /// in an error. Setting this to `true` will attempt to first dismiss an active card (if it exists), then perform
    /// presentation operations.
    var dismissesCurrentCardsInContext: Bool { get set }
    
    /// Flag indicating if touches should be passed through the content overlay view; _defaults to false_.
    ///
    /// This property will be ignored if `isContentOverlayTapToDismissEnabled` is `true`.
    var isContentOverlayTouchThroughEnabled: Bool { get set }
        
    /// The action to call when a card is about to be presented.
    var willPresentAction: (()->())? { get set }
    
    /// The action to call when a card has finished being presented.
    var didPresentAction: (()->())? { get set }
    
    /// The action to call when a card is about to be dismissed.
    var willDismissAction: ((Card.DismissalReason)->())? { get set }
    
    /// The action to call when a card has finished being dismissed.
    var didDismissAction: ((Card.DismissalReason)->())? { get set }
    
}
