//
//  Card.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

public struct Card {
    
    public struct CornerStyle {
        
        public var roundedCorners: UIRectCorner = .allCorners
        public var roundedCornerRadius: CGFloat = 32
        
        public static var `default`: CornerStyle {
            return CornerStyle()
        }
        
    }
    
    public struct ShadowStyle {
        
        public var color: UIColor = .black
        public var radius: CGFloat = 8
        public var offset: CGSize = .zero
        public var alpha: CGFloat = 0.1
        
        public static func `default`(for anchor: Anchor) -> ShadowStyle {
            
            var offset: CGSize = .zero
            
            switch anchor {
            case .top: offset = CGSize(width: 0, height: 2)
            case .left: offset = CGSize(width: 2, height: 0)
            case .bottom: offset = CGSize(width: 0, height: -2)
            case .right: offset = CGSize(width: -2, height: 0)
            case .none: break
            }
            
            var style = ShadowStyle()
            style.offset = offset
            return style
            
        }
        
        public static var none: ShadowStyle {
            
            var style = ShadowStyle()
            style.color = .clear
            style.radius = 0
            style.offset = .zero
            style.alpha = 0
            return style
            
        }
        
    }
    
    public enum Anchor {
        
        case none
        case top
        case left
        case bottom
        case right

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
    
    public enum SafeAreaAvoidance {
        
        case none
        case content
        case card
        
    }
    
    public enum DismissalReason {

        public enum Interaction {

            case swipe
            case backgroundTap

        }

        case `default`
        case interactive(Interaction)

    }
    
    public let contentView: CardContentView
    
    public var anchor: Anchor = .bottom
    public var duration: Duration = .none // TODO: Implement this
    public var statusBar: UIStatusBarStyle = .default
    public var hidesHomeIndicator: Bool = false
    public var contentOverlay: BackgroundStyle = .color(.black.withAlphaComponent(0.4))
    public var background: BackgroundStyle = .color(.white)
    public var safeAreaAvoidance: SafeAreaAvoidance = .content
    public var corners: CornerStyle = .default
    public var shadow: ShadowStyle = .default(for: .bottom)
    public var insets: UIEdgeInsets = .zero

    public var isContentOverlayTapToDismissEnabled: Bool = true
    public var isSwipeToDismissEnabled: Bool = true
    public var isBounceable: Bool = true // TODO: Implement this
    
    // TODO: Card present/dismiss animation customization
    // TODO: Card present over/under status bar ???? would be nice for status bar overlay notifications
    
    public var willPresentAction: (()->())?
    public var didPresentAction: (()->())?
    public var willDismissAction: ((DismissalReason)->())?
    public var didDismissAction: ((DismissalReason)->())?
        
    public var viewController: CardViewController? {
        return self.contentView.cardViewController
    }
    
    public init(contentView: CardContentView) {
        self.contentView = contentView
    }
    
    @discardableResult
    public func present(from viewController: UIViewController,
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
    
}

public extension Card {

    static func `default`(contentView: CardContentView) -> Card {
        return Card(contentView: contentView)
    }
    
    static func system(contentView: CardContentView) -> Card {
        
        var card = Card(contentView: contentView)
        
        card.safeAreaAvoidance = .none
        card.hidesHomeIndicator = true
        
        card.corners.roundedCornerRadius = 44
        
        card.insets = UIEdgeInsets(
            top: 6,
            left: 6,
            bottom: 6,
            right: 6
        )
        
        return card
        
    }
    
    static func alert(contentView: CardContentView) -> Card {
        
        var card = Card(contentView: contentView)
        
        card.anchor = .none
        card.safeAreaAvoidance = .none
        card.shadow = .default(for: .none)
        card.insets = .zero
        
        return card
        
    }

    static func notification(contentView: CardContentView) -> Card {

        var card = Card(contentView: contentView)
        
        card.anchor = .top
        card.safeAreaAvoidance = .card
        
        card.corners.roundedCornerRadius = 24
        card.shadow = .default(for: .top)
        
        card.insets = UIEdgeInsets(
            top: 0,
            left: 12,
            bottom: 0,
            right: 12
        )
        
        return card

    }
    
    static func toast(contentView: CardContentView) -> Card {
        
        var card = Card(contentView: contentView)
        
        card.safeAreaAvoidance = .card
        card.corners.roundedCornerRadius = 18

        card.insets = UIEdgeInsets(
            top: 0,
            left: 12,
            bottom: 0,
            right: 12
        )

        return card
        
    }

}
