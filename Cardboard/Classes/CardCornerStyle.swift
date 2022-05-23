//
//  CardCornerStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// A style object that provides various card corner properties & attributes.
public struct CardCornerStyle {
    
    /// The corners to be rounded.
    public var roundedCorners: UIRectCorner
    
    /// The rounded corner radius.
    public var roundedCornerRadius: CGFloat
    
    internal init(roundedCorners: UIRectCorner,
                  roundedCornerRadius: CGFloat) {
        
        self.roundedCorners = roundedCorners
        self.roundedCornerRadius = roundedCornerRadius
        
    }
    
}

public extension CardCornerStyle {
    
    /// An "empty" corner style.
    ///
    /// Corners: none
    ///
    /// Radius: 0
    static var none: CardCornerStyle {
        
        return CardCornerStyle(
            roundedCorners: [],
            roundedCornerRadius: 0
        )

    }
    
}
