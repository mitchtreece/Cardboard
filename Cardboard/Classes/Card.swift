//
//  Card.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

public class Card: CardBuildable, CardStyleProvider, CardActionProvider {
    
    public typealias BuilderBlock = (inout CardBuilder)->()
    
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

            case swipe
            // case action
            case background

        }

        case `default`
        case interactive(Interaction)

    }
        
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
        
    internal let view: CardContentView
    private weak var viewController: CardViewController?
    
    required public init(_ view: CardContentView,
                         _ build: BuilderBlock) {
        
        self.view = view
        
        var builder = CardBuilder()
        build(&builder)
        
        setup(builder: builder)
        
    }
    
    internal init(_ view: CardContentView) {
        self.view = view
    }
    
    // MARK: Public

//    public static func build(_ buildable: CardBuildable) -> CardProtocol {
//        
//        guard let card = buildable as? CardProtocol else {
//            fatalError("This shouldn't happen. CardBuildable always conforms to CardProtocol.")
//        }
//        
//        return card
//        
//    }
    
    // MARK: Private
    
    @discardableResult
    internal func setup(builder: CardBuilder) -> Self {
        
        self.anchor = builder.anchor
        self.animator = builder.animator
        self.duration = builder.duration
        self.statusBar = builder.statusBar
        self.hidesHomeIndicator = builder.hidesHomeIndicator
        self.isContentOverlayTapToDismissEnabled = builder.isContentOverlayTapToDismissEnabled
        self.isSwipeToDismissEnabled = builder.isSwipeToDismissEnabled
        
        self.contentOverlay = builder.contentOverlay
        self.background = builder.background
        self.edges = builder.edges
        self.corners = builder.corners
        self.shadow = builder.shadow
        
        // self.action = builder.action
        self.willPresentAction = builder.willPresentAction
        self.didPresentAction = builder.didPresentAction
        self.willDismissAction = builder.willDismissAction
        self.didDismissAction = builder.didDismissAction
        
        return self
        
    }
    
}

extension Card: CardProtocol {
    
    public func present(from viewController: UIViewController) {
                
        self.view.setup(for: self)
        
        // NOTE: The warning below is misleading.
        // The reference to `viewController` is not
        // deallocated after assignment because it is
        // retained elsewhere. Making this a strong
        // reference leads to a retain cycle.
        //
        // Currently there is no way to silence
        // this warning.
        
        self.viewController = CardViewController(
            contentView: self.view,
            styleProvider: self,
            actionProvider: self
        )
        
        self.viewController?
            .presentCard(from: viewController)
        
    }
    
    public func dismiss() {
        
        self.viewController?
            .dismissCard()
        
    }
    
}
