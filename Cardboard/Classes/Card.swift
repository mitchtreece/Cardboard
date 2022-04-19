//
//  Card.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit

public class Card {
    
    public enum Anchor {
        
        case top
        case left
        case bottom
        case right
        case center
        
    }
    
    public enum Duration {
        
        case none
        case seconds(TimeInterval)
        
    }
    
    public enum BackgroundStyle {
        
        case none
        case color(_ color: UIColor)
        case blurred(style: UIBlurEffect.Style)
        
    }
    
    public enum DismissalReason {

        public enum Interaction {

            case swipe // swipe-to-dismiss
            case content // action
            case background // background tap

        }

        case `default`
        case interactive(Interaction)

    }
    
    internal let builder: CardBuilder

    private var viewController: CardViewController?
    
    internal init(builder: CardBuilder) {
        self.builder = builder
    }
    
    // MARK: Public
    
    public static func build(_ contentView: CardContentView,
                             build: (inout CardBuilder)->()) -> CardProtocol {
        
        var builder = CardBuilder(contentView: contentView)
        build(&builder)
        
        return Card(builder: builder)
        
    }
    
    public static func build(_ builder: CardBuilder) -> CardProtocol {
        return Card(builder: builder)
    }
        
}

extension Card: CardProtocol {
    
    public func asBuilder() -> CardBuilder {
        return self.builder
    }
    
    public func present(from viewController: UIViewController) {
                
        self.builder.contentView.setup(for: self)
        
        self.viewController = CardViewController(
            contentView: self.builder.contentView,
            styleProvider: self.builder,
            actionProvider: self.builder
        )
        
        self.viewController?
            .presentCard(from: viewController)
        
    }
    
    public func dismiss() {
        
        self.viewController?
            .dismissCard()
        
    }
    
}
