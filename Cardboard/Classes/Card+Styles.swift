//
//  Card+Styles.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

public extension Card { /* Styles */
    
    // MARK: Private
    
    private static func buildCard(_ card: Card,
                                  _ build: BuilderBlock?) -> Card {
        
        guard let build = build else { return card }
        
        var builder = CardBuilder(buildable: card)
        build(&builder)

        return card
            .setup(builder: builder)
        
    }
    
    // MARK: Public
    
    /// A default-modal card style.
    /// - parameter view: The card's content view.
    /// - parameter build: An optional builder block used to customize the behavior & style of a card.
    /// - returns: A card instance.
    static func defaultModal(_ view: CardContentView,
                             _ build: BuilderBlock? = nil) -> Card {
                
        return buildCard(Card(view) { make in
            
            make.contentOverlay = .color(.black.withAlphaComponent(0.5))
            make.background = .color(.white)
            
            var edgeStyle = CardEdgeStyle()
            edgeStyle.setSafeAreaAvoidance(.content)
            make.edges = edgeStyle
            
            make.corners = CardCornerStyle(
                roundedCorners: [.topLeft, .topRight],
                roundedCornerRadius: 32
            )
            
            make.shadow = CardShadowStyle(
                color: .black,
                radius: 8,
                offset: CardShadowStyle.offset(2, for: .bottom),
                alpha: 0.1
            )
            
            make.isContentOverlayTapToDismissEnabled = true
            make.isSwipeToDismissEnabled = true
            make.dismissesCurrentCardsInContext = true
            
        }, build)
        
    }

    /// A system card style.
    /// - parameter view: The card's content view.
    /// - parameter build: An optional builder block used to customize the behavior & style of a card.
    /// - returns: A card instance.
    static func system(_ view: CardContentView,
                       _ build: BuilderBlock? = nil) -> Card {
        
        let card = Card.defaultModal(view) { make in
            
            make.hidesHomeIndicator = true
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = (UIScreen.main.cornerRadius != 0) ? UIScreen.main.cornerRadius : 8
            
            make.edges.setInsets(6)
            make.edges.setSafeAreaAvoidance(.none)
            
        }
        
        return buildCard(
            card,
            build
        )
                
    }

    /// A notification card style.
    /// - parameter view: The card's content view.
    /// - parameter build: An optional builder block used to customize the behavior & style of a card.
    /// - returns: A card instance.
    static func notification(_ view: CardContentView,
                             _ build: BuilderBlock? = nil) -> Card {

        let card = Card.defaultModal(view) { make in
            
            make.anchor = .top
            make.contentOverlay = .none
            make.duration = .seconds(3)
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 24
            make.shadow.offset = CardShadowStyle.offset(2, for: .top)
            make.isContentOverlayTapToDismissEnabled = false
            make.isContentOverlayTouchThroughEnabled = true
                        
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setInset(12, for: .top, when: .safeAreaLegacyStatusBar)
            make.edges.setInset(12, for: .bottom, when: .safeArea(false))
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }
        
        return buildCard(
            card,
            build
        )
        
    }
    
    /// A banner card style.
    /// - parameter view: The card's content view.
    /// - parameter build: An optional builder block used to customize the behavior & style of a card.
    /// - returns: A card instance.
    static func banner(_ view: CardContentView,
                       _ build: BuilderBlock? = nil) -> Card {
        
        let card = Card.notification(view) { make in
            
            make.corners.roundedCorners = [.bottomLeft, .bottomRight]
            
            make.edges.setInsets(0)
            make.edges.setSafeAreaAvoidance(.content, for: [.top, .bottom])
            
        }
        
        return buildCard(
            card,
            build
        )
        
    }
    
    /// A toast card style.
    /// - parameter view: The card's content view.
    /// - parameter build: An optional builder block used to customize the behavior & style of a card.
    /// - returns: A card instance.
    static func toast(_ view: CardContentView,
                      _ build: BuilderBlock? = nil) -> Card {
        
        let card = Card.notification(view) { make in
            
            make.anchor = .bottom
            make.corners.roundedCornerRadius = 16
                        
        }
        
        return buildCard(
            card,
            build
        )
                
    }
    
    /// An alert card style.
    /// - parameter view: The card's content view.
    /// - parameter build: An optional builder block used to customize the behavior & style of a card.
    /// - returns: A card instance.
    static func alert(_ view: CardContentView,
                      _ build: BuilderBlock? = nil) -> Card {
        
        let card = Card.defaultModal(view) { make in
            
            make.anchor = .center
            make.animator = AlertCardAnimator()
            make.corners.roundedCorners = .allCorners
            make.shadow.offset = CardShadowStyle.offset(2, for: .center)
            make.edges = .none
            
        }
        
        return buildCard(
            card,
            build
        )
        
    }

}
