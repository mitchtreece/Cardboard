//
//  CardStyleProvider.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

internal protocol CardStyleProvider {
    
    var anchor: Card.Anchor { get }
    var animator: CardAnimator { get }
    var duration: Card.Duration { get }
    var statusBar: UIStatusBarStyle { get }
    var hidesHomeIndicator: Bool { get }
    var isContentOverlayTapToDismissEnabled: Bool { get }
    var isContentOverlayTouchThroughEnabled: Bool { get }
    var isSwipeToDismissEnabled: Bool { get }
    
    var contentOverlay: Card.BackgroundStyle { get }
    var background: Card.BackgroundStyle { get }
    var edges: CardEdgeStyle { get }
    var corners: CardCornerStyle { get }
    var shadow: CardShadowStyle { get }
    
}

internal extension CardStyleProvider {
    
    var edgesForAnchor: [CardEdgeStyle.Edge] {
        
        var edges = [CardEdgeStyle.Edge]()

        switch self.anchor {
        case .top:

            edges = [
                self.edges.left,
                self.edges.top,
                self.edges.right
            ]

        case .left:

            edges = [
                self.edges.top,
                self.edges.left,
                self.edges.bottom
            ]

        case .bottom:

            edges = [
                self.edges.left,
                self.edges.bottom,
                self.edges.right
            ]

        case .right:

            edges = [
                self.edges.top,
                self.edges.right,
                self.edges.bottom
            ]

        default: break
        }

        return edges
        
    }
    
}
