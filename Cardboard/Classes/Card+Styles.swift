//
//  Card+Styles.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

public extension Card { /* Styles */
    
    private static func buildCard(_ card: Card,
                                  _ build: BuilderBlock?) -> CardProtocol {
        
        guard let build = build else { return card }
        
        var builder = CardBuilder(buildable: card)
        build(&builder)

        return card
            .setup(builder: builder)
        
    }
    
    // MARK: Public
    
    static func `default`(_ view: CardContentView,
                          _ build: BuilderBlock? = nil) -> CardProtocol {
                
        return buildCard(
            Card(view),
            build
        )
        
    }

    static func system(_ view: CardContentView,
                       _ build: BuilderBlock? = nil) -> CardProtocol {
        
        return buildCard(Card(view) { make in
            
            make.anchor = .bottom
            make.hidesHomeIndicator = true
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 44
            make.shadow = .default(for: .bottom)
            
            // TODO: Make corner radius smaller for legacy devices
            
            make.edges.setInsets(6)
            make.edges.setSafeAreaAvoidance(.none)
            
        }, build)
                
    }

    static func notification(_ view: CardContentView,
                             _ build: BuilderBlock? = nil) -> CardProtocol {

        return buildCard(Card(view) { make in
            
            make.anchor = .top
            make.duration = .seconds(3)
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 24
            make.shadow = .default(for: .top)
            
            // TODO: Add top inset for legacy devices
            
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }, build)
        
    }
    
    static func toast(_ view: CardContentView,
                      _ build: BuilderBlock? = nil) -> CardProtocol {
        
        return buildCard(Card(view) { make in
            
            make.anchor = .bottom
            make.duration = .seconds(3)
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 16
            make.shadow = .default(for: .bottom)
            
            // TODO: Add bottom inset for legacy devices
            
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }, build)
                
    }
    
    static func alert(_ view: CardContentView,
                      _ build: BuilderBlock? = nil) -> CardProtocol {
        
        return buildCard(Card(view) { make in
            
            make.anchor = .center
            make.animator = AlertCardAnimator()
            make.corners.roundedCorners = .allCorners
            make.shadow = .default(for: .center)
            
            make.edges.setInsets(0)
            make.edges.setSafeAreaAvoidance(.none)
            
        }, build)
        
    }

}
