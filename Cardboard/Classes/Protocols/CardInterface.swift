//
//  CardInterface.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

/// A protocol describing the ways a card can be created & interacted with.
public protocol CardInterface: AnyObject {
    
    /// Initializes a card with a content view & builder block.
    /// - parameter view: The card's content view.
    /// - parameter build: A builder block used to customize the behavior & style of a card.
    init(_ view: CardContentView,
         _ build: Card.BuilderBlock)
    
    /// Presents the card from a given view controller.
    /// - parameter viewController: The view controller to present the card from.
    /// - returns: A card interface.
    @discardableResult
    func present(from viewController: UIViewController) -> Self
    
    /// Dismisses the card.
    func dismiss()
    
}
