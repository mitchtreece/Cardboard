//
//  CardBuildable.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

public protocol CardBuildable {
    
    var anchor: Card.Anchor { get set }
    var animator: CardAnimator { get set }
    var duration: Card.Duration { get set }
    var statusBar: UIStatusBarStyle { get set }
    var hidesHomeIndicator: Bool { get set }
    var isContentOverlayTapToDismissEnabled: Bool { get set }
    var isSwipeToDismissEnabled: Bool { get set }
    
    var contentOverlay: Card.BackgroundStyle { get set }
    var background: Card.BackgroundStyle { get set }
    var edges: CardEdgeStyle { get set }
    var corners: CardCornerStyle { get set }
    var shadow: CardShadowStyle { get set }
    
    // var action: (()->())? { get set }
    var willPresentAction: (()->())? { get set }
    var didPresentAction: (()->())? { get set }
    var willDismissAction: ((Card.DismissalReason)->())? { get set }
    var didDismissAction: ((Card.DismissalReason)->())? { get set }
    
}
