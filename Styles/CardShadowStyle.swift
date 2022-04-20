//
//  CardShadowStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// A style object that provides various
/// card shadow properties & attributes.
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
    
    /// A default shadow style for a given anchor.
    /// - parameter anchor: The anchor to use when calculating the style.
    ///
    /// Color: black
    ///
    /// radius: 8
    ///
    /// offset: 2 (based on anchor)
    ///
    /// alpha: 0.1
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
