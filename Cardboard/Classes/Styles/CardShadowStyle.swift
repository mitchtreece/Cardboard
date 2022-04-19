//
//  CardShadowStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

public struct CardShadowStyle {
    
    public var color: UIColor
    public var radius: CGFloat
    public var offset: CGSize
    public var alpha: CGFloat
    
    public init(color: UIColor,
                radius: CGFloat,
                offset: CGSize,
                alpha: CGFloat) {
        
        self.color = color
        self.radius = radius
        self.offset = offset
        self.alpha = alpha
        
    }
    
}

public extension CardShadowStyle {
    
    static func `default`(for anchor: Card.Anchor) -> CardShadowStyle {
        
        var offset: CGSize = .zero
        
        switch anchor {
        case .top: offset = CGSize(width: 0, height: 2)
        case .left: offset = CGSize(width: 2, height: 0)
        case .bottom: offset = CGSize(width: 0, height: -2)
        case .right: offset = CGSize(width: -2, height: 0)
        case .center: break
        }
        
        return CardShadowStyle(
            color: .black,
            radius: 8,
            offset: offset,
            alpha: 0.1
        )

    }
    
    static var none: CardShadowStyle {
        
        return CardShadowStyle(
            color: .clear,
            radius: 0,
            offset: .zero,
            alpha: 0
        )

    }
    
}
