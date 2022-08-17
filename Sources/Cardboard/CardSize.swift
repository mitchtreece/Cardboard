//
//  CardSize.swift
//  Cardboard
//
//  Created by Mitch Treece on 5/23/22.
//

import Foundation

/// An object that provides various card size properties & attributes.
public struct CardSize {
    
    /// Representation of the various sizing mode types.
    public enum Mode {
        
        /// A content-based sizing mode.
        case content
        
        /// A fixed-value sizing mode.
        case fixed(CGFloat)
        
        /// A fixed-size sizing mode.
        case fixedSize(CGSize)
        
    }
    
    /// The sizing mode; _defaults to content_.
    public var mode: Mode = .content
    
}

public extension CardSize {
    
    /// A default size configuration.
    ///
    /// Mode: default
    static var `default`: CardSize {
        return CardSize()
    }
    
}
