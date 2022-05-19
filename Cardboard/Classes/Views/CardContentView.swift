//
//  CardContentView.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

/// A card content-view base class that provides an interface for interacting with the underlying card system.
open class CardContentView: UIView {
    
    /// The view's backing card.
    public private(set) weak var card: Card!
    
    internal func setup(for card: Card) {
        self.card = card
    }
    
}
