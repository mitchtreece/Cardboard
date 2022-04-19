//
//  CardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

open class CardAnimator {
        
    public struct Context {
        
        public let sourceView: UIView
        public let containerView: UIView
        public let contentOverlayView: UIView
        public let cardView: UIView
        public let anchor: Card.Anchor
        public let insets: UIEdgeInsets
        public let animation: Animation
        
    }
    
    public enum Animation {
        
        case presentation
        case dismissal
        
    }
    
    public var duration: TimeInterval = 0.4 {
        didSet {
            setupAnimator()
        }
    }
    
    public var timingProvider: UITimingCurveProvider! {
        didSet {
            setupAnimator()
        }
    }
    
    internal private(set) var animator: UIViewPropertyAnimator!
    
    public init() {
        
        // Material (standard) timing
        
        self.timingProvider = UISpringTimingParameters(
            dampingRatio: 0.8,
            initialVelocity: .init(dx: 0.4, dy: 0.4)
        )
        
        setupAnimator()
        
    }
    
    open func setup(ctx: Context) {
        //
    }
    
    open func animate(ctx: Context) {
        fatalError("CardAnimtor subclasses must implement animate(ctx:)")
    }
    
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
