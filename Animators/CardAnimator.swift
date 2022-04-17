//
//  CardAnimator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

public class CardAnimator {
    
    public typealias ContextBlock = (Context)->()
    
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
    
    internal let setup: ContextBlock
    internal let animations: ContextBlock
    internal let completion: ContextBlock?
    
    internal private(set) var animator: UIViewPropertyAnimator!
    
    public init(setup: @escaping ContextBlock,
                animations: @escaping ContextBlock,
                completion: ContextBlock?) {
        
        self.setup = setup
        self.animations = animations
        self.completion = completion
        
        // Material (standard) timing
        
        self.timingProvider = UISpringTimingParameters(
            dampingRatio: 0.8,
            initialVelocity: .init(dx: 0.4, dy: 0.4)
        )
        
        setupAnimator()
        
    }
    
    private func setupAnimator() {
     
        self.animator = UIViewPropertyAnimator(
            duration: self.duration,
            timingParameters: self.timingProvider
        )
        
    }
    
}
