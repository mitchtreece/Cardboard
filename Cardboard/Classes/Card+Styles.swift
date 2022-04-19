//
//  Card+Styles.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

public extension Card { /* Styles */
    
    static func `default`(contentView: CardContentView) -> Card {
        return Card(contentView: contentView)
    }

    static func system(contentView: CardContentView) -> Card {
        
        var card = Card(contentView: contentView)
        let anchor: Anchor = .bottom
        
        card.anchor = .bottom
        card.hidesHomeIndicator = true
        card.corners.roundedCornerRadius = 44
        card.shadow = .default(for: anchor)

        card.edges.setInsets(6)
        card.edges.setSafeAreaAvoidance(.none)
        
        return card
        
    }

    static func notification(contentView: CardContentView) -> Card {

        var card = Card(contentView: contentView)
        let anchor: Anchor = .top

        card.anchor = anchor
        card.duration = .seconds(3)
        card.corners.roundedCornerRadius = 24
        card.shadow = .default(for: anchor)
        
        card.edges.setInsets(12, for: [.left, .right])
        card.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
        
        return card

    }
    
    static func toast(contentView: CardContentView) -> Card {
        
        var card = Card(contentView: contentView)
        let anchor: Anchor = .bottom
        
        card.anchor = anchor
        card.duration = .seconds(3)
        card.corners.roundedCornerRadius = 16
        card.shadow = .default(for: anchor)
        
        card.edges.setInsets(12, for: [.left, .right])
        card.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
        
        return card
        
    }
    
    static func alert(contentView: CardContentView) -> Card {
        
        var card = Card(contentView: contentView)
        let anchor: Anchor = .center
                
        card.animator = AlertCardAnimator()
        
        card.anchor = anchor
        card.shadow = .default(for: anchor)

        card.edges.setInsets(0)
        card.edges.setSafeAreaAvoidance(.none)

        return card
        
    }

}
