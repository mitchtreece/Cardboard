//
//  CardCornerStyle.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

public struct CardCornerStyle {
    
    public var roundedCorners: UIRectCorner
    public var roundedCornerRadius: CGFloat
    
    public init(roundedCorners: UIRectCorner,
                roundedCornerRadius: CGFloat) {
        
        self.roundedCorners = roundedCorners
        self.roundedCornerRadius = roundedCornerRadius
        
    }
    
}

public extension CardCornerStyle {
    
    static var `default`: CardCornerStyle {
        
        return CardCornerStyle(
            roundedCorners: [.topLeft, .topRight],
            roundedCornerRadius: 32
        )
        
    }
    
    static var none: CardCornerStyle {
        
        return CardCornerStyle(
            roundedCorners: [],
            roundedCornerRadius: 0
        )

    }
    
}
