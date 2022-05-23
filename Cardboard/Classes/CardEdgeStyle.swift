//
//  CardEdgeStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// A style object that provides various card edge properties & attributes.
public struct CardEdgeStyle {
    
    /// An edge object that provides various properties & attributes related to an edge.
    public struct Edge {
        
        /// Representation of the various edge types.
        public enum EdgeType {
            
            /// A top edge.
            case top
            
            /// A left edge.
            case left
            
            /// A bottom edge.
            case bottom
            
            /// A right edge.
            case right
            
        }
        
        /// Representation of the various safe-area avoidance types.
        public enum SafeAreaAvoidance {
            
            /// No safe-area avoidance.
            case none
            
            /// Card-based safe-area avoidance.
            case card
            
            /// Content-based safe-area avoidance.
            case content
            
        }
        
        /// Representation of the various inset condition types.
        public enum InsetCondition {
            
            /// Always apply insets
            case always
            
            /// Apply insets conditionally based on an edge's safe-area inset value is
            /// equal to `0` or not.
            case safeArea(Bool)
            
            /// Apply insets conditionally if an edge's safe-area inset value is equal
            /// to the legacy status bar height.
            case safeAreaLegacyStatusBar
                        
            /// Apply insets conditionally using a custom function.
            case custom(()->(Bool))
            
        }
        
        /// The edge's type.
        public let type: EdgeType
                
        /// The edge's safe-area avoidance type.
        public var safeAreaAvoidance: SafeAreaAvoidance
        
        /// The edge's inset.
        public var inset: CGFloat
        
        /// The edge's inset condition.
        public var insetCondition: InsetCondition
        
        internal init(type: EdgeType) {
            
            self.type = type
            self.safeAreaAvoidance = .none
            self.inset = 0
            self.insetCondition = .always
            
        }
        
    }
    
    /// The style's top edge settings.
    public var top = Edge(type: .top)
    
    /// The style's left edge settings.
    public var left = Edge(type: .left)
    
    /// The style's bottom edge settings.
    public var bottom = Edge(type: .bottom)
    
    /// The style's right edge settings.
    public var right = Edge(type: .right)
    
    internal var all: [Edge] {
        
        return [
            self.top,
            self.left,
            self.bottom,
            self.right
        ]
        
    }
    
    /// Sets an edge inset.
    /// - parameter inset: The inset value.
    /// - parameter edge: The edge to apply this inset to.
    /// - parameter when: The edge inset condition.
    public mutating func setInset(_ inset: CGFloat,
                                  for edge: Edge.EdgeType,
                                  when condition: Edge.InsetCondition = .always) {
        
        switch edge {
        case .top:
            
            self.top.inset = inset
            self.top.insetCondition = condition
            
        case .left:
            
            self.left.inset = inset
            self.left.insetCondition = condition

        case .bottom:
            
            self.bottom.inset = inset
            self.bottom.insetCondition = condition

        case .right:
            
            self.right.inset = inset
            self.right.insetCondition = condition

        }
        
    }
        
    /// Sets edge insets.
    /// - parameter inset: The inset value.
    /// - parameter edges: The edge's to apply this inset to; _defaults to all_.
    /// - parameter when: The edge inset condition.
    public mutating func setInsets(_ inset: CGFloat,
                                   for edges: [Edge.EdgeType] = [.top, .left, .bottom, .right],
                                   when condition: Edge.InsetCondition = .always) {
        
        for edge in edges {
            
            setInset(
                inset,
                for: edge,
                when: condition
            )
            
        }
        
    }
    
    /// Sets an edge safe-area avoidance.
    /// - parameter avoidance: The safe-area avoidance type.
    /// - parameter edge: The edge to apply this safe-area avoidance type to.
    public mutating func setSafeAreaAvoidance(_ avoidance: Edge.SafeAreaAvoidance,
                                              for edge: Edge.EdgeType) {
        
        switch edge {
        case .top: self.top.safeAreaAvoidance = avoidance
        case .left: self.left.safeAreaAvoidance = avoidance
        case .bottom: self.bottom.safeAreaAvoidance = avoidance
        case .right: self.right.safeAreaAvoidance = avoidance
        }
        
    }
    
    /// Sets edge safe-area avoidances.
    /// - parameter avoidance: The safe-area avoidance type.
    /// - parameter edges: The edge's to apply this safe-area avoidance type to; _defaults to all_.
    public mutating func setSafeAreaAvoidance(_ avoidance: Edge.SafeAreaAvoidance,
                                              for edges: [Edge.EdgeType] = [.top, .left, .bottom, .right]) {
        
        for edge in edges {
            
            setSafeAreaAvoidance(
                avoidance,
                for: edge
            )
            
        }
        
    }
        
}

public extension CardEdgeStyle {
    
    /// An "empty" edge style.
    ///
    /// Insets: 0
    ///
    /// Safe Area Avoidance: none
    static var none: CardEdgeStyle {
        return CardEdgeStyle()
    }
    
}
