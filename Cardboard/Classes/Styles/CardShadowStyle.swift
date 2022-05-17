//
//  CardShadowStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// A style object that provides various card shadow properties & attributes.
public struct CardShadowStyle {
    
    /// The shadow color.
    public var color: UIColor
    
    /// The shadow radius.
    public var radius: CGFloat
    
    /// The shadow offset.
    public var offset: CGSize
    
    /// The shadow alpha.
    public var alpha: CGFloat
    
    internal init(color: UIColor,
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
    
    /// Gets a anchor-normalized shadow offset value.
    /// - parameter value: The offset value.
    /// - parameter anchor: The card anchor.
    /// - returns: An anchor-normalized shadow offset value.
    static func offset(_ value: CGFloat,
                       for anchor: Card.Anchor) -> CGSize {
        
        switch anchor {
        case .top: return CGSize(width: 0, height: value)
        case .left: return CGSize(width: value, height: 0)
        case .bottom: return CGSize(width: 0, height: -value)
        case .right: return CGSize(width: -value, height: 0)
        case .center: return .zero
        }
        
    }
    
    /// An "empty" shadow style.
    ///
    /// Color: clear
    ///
    /// radius: 0
    ///
    /// offset: 0
    ///
    /// alpha: 0
    static var none: CardShadowStyle {
        
        return CardShadowStyle(
            color: .clear,
            radius: 0,
            offset: .zero,
            alpha: 0
        )

    }
    
}
