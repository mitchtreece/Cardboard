//
//  Card.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

/// Class that contains various properties, attributes, & functions that makeup a card-based presentation.
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
    
    // These are documented via `CardBuildable`
    
    internal var anchor: Card.Anchor = .bottom
    internal var animator: CardAnimator = DefaultCardAnimator()
    internal var duration: Card.Duration = .none
    internal var statusBar: UIStatusBarStyle = .default
    internal var contentOverlay: Card.BackgroundStyle = .none
    internal var background: Card.BackgroundStyle = .none
    internal var edges: CardEdgeStyle = .none
    internal var corners: CardCornerStyle = .none
    internal var shadow: CardShadowStyle = .none
    internal var hidesHomeIndicator: Bool = false
    internal var isSwipeToDismissEnabled: Bool = false
    internal var isContentOverlayTapToDismissEnabled: Bool = false
    internal var isContentOverlayTouchThroughEnabled: Bool = false
    internal var dismissesCurrentCardsInContext: Bool = false

    internal var willPresentAction: (()->())?
    internal var didPresentAction: (()->())?
    internal var willDismissAction: ((Card.DismissalReason)->())?
    internal var didDismissAction: ((Card.DismissalReason)->())?
        
    internal let view: CardContentView
    private weak var viewController: CardViewController?
    
    // MARK: Public
    
    /// Initializes a card with a content view & builder block.
    /// - parameter view: The card's content view.
    /// - parameter build: A builder block used to customize the behavior & style of a card.
    public init(_ view: CardContentView,
                         _ build: BuilderBlock) {
        
        self.view = view
        
        var builder = CardBuilder()
        build(&builder)
        
        setup(builder: builder)
        
    }
        
    /// Presents the card from a given view controller.
    /// - parameter viewController: The view controller to present the card from.
    /// - returns: The card instance.
    @discardableResult
    public func present(from viewController: UIViewController) -> Self {
                
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
        
        return self
        
    }
    
    /// Dismisses the card.
    public func dismiss() {
        
        self.viewController?
            .dismissCard()
        
    }

    // MARK: Private
    
    internal init(_ view: CardContentView) {
        self.view = view
    }
    
    @discardableResult
    internal func setup(builder: CardBuilder) -> Self {
        
        self.anchor = builder.anchor
        self.animator = builder.animator
        self.duration = builder.duration
        self.statusBar = builder.statusBar
        self.contentOverlay = builder.contentOverlay
        self.background = builder.background
        self.edges = builder.edges
        self.corners = builder.corners
        self.shadow = builder.shadow
        self.hidesHomeIndicator = builder.hidesHomeIndicator
        self.isContentOverlayTapToDismissEnabled = builder.isContentOverlayTapToDismissEnabled
        self.isContentOverlayTouchThroughEnabled = builder.isContentOverlayTouchThroughEnabled
        self.dismissesCurrentCardsInContext = builder.dismissesCurrentCardsInContext
        self.isSwipeToDismissEnabled = builder.isSwipeToDismissEnabled
        
        self.willPresentAction = builder.willPresentAction
        self.didPresentAction = builder.didPresentAction
        self.willDismissAction = builder.willDismissAction
        self.didDismissAction = builder.didDismissAction
        
        return self
        
    }
    
}
