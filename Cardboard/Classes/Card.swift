//
//  Card.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

public struct Card {
    
    public enum Anchor {
        
        case top
        case left
        case bottom
        case right
        case center

    }
    
    public enum Duration {
        
        case none
        case seconds(TimeInterval)
        
    }
    
    public enum BackgroundStyle {
        
        case none
        case color(_ color: UIColor)
        case blurred(style: UIBlurEffect.Style)
        
    }
    
    public enum DismissalReason {

        public enum Interaction {

            case swipe // swipe-to-dismiss
            case content // action
            case background // background tap

        }

        case `default`
        case interactive(Interaction)

    }
    
    public let contentView: CardContentView
    
    public var anchor: Anchor = .bottom
    public var animator: CardAnimator = SlideCardAnimator()
    public var duration: Duration = .none
    public var statusBar: UIStatusBarStyle = .default
    public var hidesHomeIndicator: Bool = false
    public var isContentOverlayTapToDismissEnabled: Bool = true
    public var isSwipeToDismissEnabled: Bool = true
//    public var isBounceable: Bool = true // TODO: Implement this
    
    // Styles
    
    public var contentOverlay: BackgroundStyle = .color(.black.withAlphaComponent(0.5))
    public var background: BackgroundStyle = .color(.white)
    public var edges: CardEdgeStyle = .default
    public var corners: CardCornerStyle = .default
    public var shadow: CardShadowStyle = .default(for: .bottom)
    
    // Actions
        
    public var action: (()->())?
    public var willPresentAction: (()->())?
    public var didPresentAction: (()->())?
    public var willDismissAction: ((DismissalReason)->())?
    public var didDismissAction: ((DismissalReason)->())?
        
    public var viewController: CardViewController? {
        return self.contentView.cardViewController
    }
    
    internal init(contentView: CardContentView) {
        self.contentView = contentView
    }
    
    @discardableResult
    public func present(from viewController: UIViewController,
                        animator: CardAnimator? = nil,
                        completion: (()->())? = nil) -> Self {
        
        CardViewController(card: self)
            .presentCard(
                from: viewController,
                completion: completion
            )
        
        return self
        
    }
    
    public func dismiss(completion: (()->())? = nil) {
        
        self.contentView
            .cardViewController?
            .dismissCard(completion: completion)
        
    }
    
    internal func edges(for anchor: Anchor) -> [CardEdgeStyle.Edge] {
        
        var edges = [CardEdgeStyle.Edge]()
        
        switch anchor {
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
