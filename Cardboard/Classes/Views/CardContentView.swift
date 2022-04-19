//
//  CardContentView.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

open class CardContentView: UIView {
    
    public private(set) weak var card: CardProtocol?
    
    internal func setup(for card: CardProtocol) {
        self.card = card
    }
    
}
