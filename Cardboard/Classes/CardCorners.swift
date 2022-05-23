//
//  CardCorners.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

/// An object that provides various card corner properties & attributes.
public struct CardCorners {
    
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

public extension CardCorners {
    
    /// An "empty" corner configuration.
    ///
    /// Corners: none
    ///
    /// Radius: 0
    static var none: CardCorners {
        
        return CardCorners(
            roundedCorners: [],
            roundedCornerRadius: 0
        )

    }
    
}
