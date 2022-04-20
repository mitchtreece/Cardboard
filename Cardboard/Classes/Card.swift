//
//  Card.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

/// Class that contains various properties, attributes, & functions
/// that makeup a card-based presentation.
public class Card: CardBuildable, CardStyleProvider, CardActionProvider {
    
    /// A card-builder type.
    public typealias BuilderBlock = (inout CardBuilder)->()
    
    /// Representation of the various card anchor types.
    public enum Anchor {
        
        /// A top anchor.
        case top
        
        /// A left anchor.
        case left
        
        /// A bottom anchor.
        case bottom
        
        /// A right anchor.
        case right
        
        /// A center anchor.
        case center
        
    }
    
    /// Representation of the various card duration types.
    public enum Duration {
        
        /// No duration.
        case none
        
        /// Duration in seconds.
        case seconds(TimeInterval)
        
    }
    
    /// Representation of the various card background style types.
    public enum BackgroundStyle {
        
        /// No style.
        case none
        
        /// A color style.
        case color(_ color: UIColor)
        
        /// A blurred style.
        case blurred(style: UIBlurEffect.Style)
        
    }
    
    /// Representation of the various card dismissal types.
    public enum DismissalReason {

        /// Representation of the various interactive dismissal types.
        public enum Interaction {

            /// A swipe interaction.
            case swipe
            
            // case action
            
            /// A background-tap interaction.
            case background

        }

        /// A default dismissal reason.
        case `default`
        
        /// An interactive dismissal reason.
        case interactive(Interaction)

    }
    
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
