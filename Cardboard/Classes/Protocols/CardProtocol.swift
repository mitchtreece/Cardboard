//
//  CardProtocol.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/19/22.
//

import UIKit

public protocol CardProtocol: AnyObject {
    
    init(_ view: CardContentView,
         _ build: Card.BuilderBlock)
    
    func present(from viewController: UIViewController)
    func dismiss()
    
}
