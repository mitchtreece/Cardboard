//
//  CardContentView.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

open class CardContentView: UIView {
    
    public private(set) weak var cardViewController: CardViewController?
    
    internal func setup(in viewController: CardViewController) {
        self.cardViewController = viewController
    }
    
}
