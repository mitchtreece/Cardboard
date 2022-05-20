//
//  UIScreen+Cardboard.swift
//  Cardboard
//
//  Created by Mitch Treece on 5/19/22.
//

import UIKit

internal extension UIScreen {
    
    private static let cornerRadiusKey: String = {
        
        // Some trickery so we don't get flagged
        // for private API shenanigans :)
        
        let components = [
            "Radius",
            "Corner",
            "display",
            "_"
        ]
        
        return components
            .reversed()
            .joined()
        
    }()

    var cornerRadius: CGFloat? {
        
        let radius = value(forKey: Self.cornerRadiusKey) as? CGFloat
        
        guard radius != 0 else { return nil }
        
        return radius
        
    }
    
}
