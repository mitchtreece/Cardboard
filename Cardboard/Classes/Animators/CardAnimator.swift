//
//  CardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// Card animator class that controls the display of card presentation & dismissals.
open class CardAnimator {
        
    /// An animation context that provides various properties & attributes used during card presentation & dismissals.
    public struct Context {
        
        /// The animation's type.
        public let animation: Animation
        
        /// The presenting view controller's view.
        public let sourceView: UIView
        
        /// The card presentation's root container view.
        public let containerView: UIView
        
        /// The content overlay container view.
        public let contentOverlayView: UIView
        
        /// The card view.
        public let cardView: UIView
        
        /// The card's anchor.
        public let anchor: Card.Anchor
        
        /// The card's insets.
        public let insets: UIEdgeInsets
        
    }
    
    /// Representation of the various animation types.
    public enum Animation {
        
        /// A presentation animation.
        case presentation
        
        /// A dismissal animation.
        case dismissal
        
    }
    
    /// The animator's animation duration; _defaults to 0.4_.
    public var duration: TimeInterval = 0.4 {
        didSet {
            setupAnimator()
        }
    }
    
    /// The animator's animation timing provider; _defaults to spring(damping: 0.8, velocity: 0.4)_.
    public var timingProvider: UITimingCurveProvider! {
        didSet {
            setupAnimator()
        }
    }
    
    internal private(set) var animator: UIViewPropertyAnimator!
    
    /// Initializes a card animator.
    public init() {
                
        self.timingProvider = UISpringTimingParameters(
            dampingRatio: 0.8,
            initialVelocity: .init(dx: 0.4, dy: 0.4)
        )
        
        setupAnimator()
        
    }
    
    /// Called right before animations are about to start.
    /// Override this function to provide custom setup logic.
    /// - parameter ctx: The animation context.
    open func setup(ctx: Context) {
        //
    }
    
    /// Called during animations are being performed.
    /// Override this function and implement your custom animation logic.
    /// - parameter ctx: The animation context.
    open func animate(ctx: Context) {
        fatalError("CardAnimtor subclasses must implement animate(ctx:)")
    }
      
    /// Called after animations are finished.
    /// Override this function to provide custom cleanup logic.
    /// - parameter ctx: The animation context.
    open func cleanup(ctx: Context) {
        //
    }
    
    // MARK: Private
    
    private func setupAnimator() {
     
        self.animator = UIViewPropertyAnimator(
            duration: self.duration,
            timingParameters: self.timingProvider
        )
        
    }
    
}
