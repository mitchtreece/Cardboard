//
//  CardActionProvider.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import Foundation

internal protocol CardActionProvider {
    
    // var action: (()->())? { get }
    var willPresentAction: (()->())? { get }
    var didPresentAction: (()->())? { get }
    var willDismissAction: ((Card.DismissalReason)->())? { get }
    var didDismissAction: ((Card.DismissalReason)->())? { get }
    
}
