//
//  CardEdgeStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

public struct CardEdgeStyle {
    
    public struct Edge {
        
        public enum EdgeType {
            
            case top
            case left
            case bottom
            case right
            
        }
        
        public enum SafeAreaAvoidance {
            
            case none
            case card
            case content
            
        }
        
        public let type: EdgeType
        public var safeAreaAvoidance: SafeAreaAvoidance
        public var inset: CGFloat
        
        internal init(type: EdgeType) {
            
            self.type = type
            self.safeAreaAvoidance = .none
            self.inset = 0
            
        }
        
    }
    
    public var top = Edge(type: .top)
    public var left = Edge(type: .left)
    public var bottom = Edge(type: .bottom)
    public var right = Edge(type: .right)
        
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
    
    static var `default`: CardEdgeStyle {
        
        var style = CardEdgeStyle()
        style.setSafeAreaAvoidance(.content)
        return style
        
    }
    
}
