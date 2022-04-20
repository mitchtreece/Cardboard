//
//  CardEdgeStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// A style object that provides various
/// card edge properties & attributes.
public struct CardEdgeStyle {
    
    /// An edge object that provides various
    /// properties & attributes related to
    /// edge styling.
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
        
        /// The edge's type.
        public let type: EdgeType
        
        /// The edge's safe-area avoidance type.
        public var safeAreaAvoidance: SafeAreaAvoidance
        
        /// The edge's inset.
        public var inset: CGFloat
        
        internal init(type: EdgeType) {
            
            self.type = type
            self.safeAreaAvoidance = .none
            self.inset = 0
            
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
        
    /// Sets edge insets.
    /// - parameter inset: The inset value.
    /// - parameter edges: The edge's to apply this inset to; _defaults to all_.
    public mutating func setInsets(_ inset: CGFloat,
                                   for edges: [Edge.EdgeType] = [.top, .left, .bottom, .right]) {
        
        for edge in edges {
            
            switch edge {
            case .top: self.top.inset = inset
            case .left: self.left.inset = inset
            case .bottom: self.bottom.inset = inset
            case .right: self.right.inset = inset
            }
            
        }
        
    }
    
    /// Sets edge safe-area avoidance.
    /// - parameter avoidance: The safe-area avoidance type.
    /// - parameter edges: The edge's to apply this safe-area avoidance type to; _defaults to all_.
    public mutating func setSafeAreaAvoidance(_ avoidance: Edge.SafeAreaAvoidance,
                                              for edges: [Edge.EdgeType] = [.top, .left, .bottom, .right]) {
        
        for edge in edges {
            
            switch edge {
            case .top: self.top.safeAreaAvoidance = avoidance
            case .left: self.left.safeAreaAvoidance = avoidance
            case .bottom: self.bottom.safeAreaAvoidance = avoidance
            case .right: self.right.safeAreaAvoidance = avoidance
            }
            
        }
        
    }
        
}

public extension CardEdgeStyle {
    
    /// A default edge style.
    ///
    /// Insets: 0
    ///
    /// Safe Area Avoidance: content
    static var `default`: CardEdgeStyle {
        
        var style = CardEdgeStyle()
        style.setSafeAreaAvoidance(.content)
        return style
        
    }
    
}
