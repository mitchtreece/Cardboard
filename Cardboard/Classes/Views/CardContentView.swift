//
//  CardContentView.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

/// A card content-view base class that provides
/// an interface for interacting with the underlying
/// card system.
open class CardContentView: UIView {
    
    /// The view's card interface.
    public private(set) weak var card: CardProtocol!
    
    internal func setup(for card: CardProtocol) {
        self.card = card
    }
    
}
