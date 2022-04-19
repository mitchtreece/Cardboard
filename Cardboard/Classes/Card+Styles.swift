//
//  Card+Styles.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import Foundation

public extension Card { /* Styles */
    
    static func `default`(_ contentView: CardContentView) -> CardProtocol {
        
        // TODO: Actually make this a builder & migrate base builder values to 0-based stuff
        return Card(builder: CardBuilder(contentView: contentView))
        
    }

    static func system(_ contentView: CardContentView) -> CardProtocol {
        
        return Card.build(contentView) { make in
            
            make.anchor = .bottom
            make.hidesHomeIndicator = true
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 44
            make.shadow = .default(for: .bottom)
            
            // TODO: Make corner radius smaller for legacy devices
            
            make.edges.setInsets(6)
            make.edges.setSafeAreaAvoidance(.none)
            
        }
        
    }

    static func notification(_ contentView: CardContentView) -> CardProtocol {

        return Card.build(contentView) { make in
            
            make.anchor = .top
            make.duration = .seconds(3)
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 24
            make.shadow = .default(for: .top)
            
            // TODO: Add top inset for legacy devices
            
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }

    }
    
    static func toast(_ contentView: CardContentView) -> CardProtocol {
        
        return Card.build(contentView) { make in
            
            make.anchor = .bottom
            make.duration = .seconds(3)
            make.corners.roundedCorners = .allCorners
            make.corners.roundedCornerRadius = 16
            make.shadow = .default(for: .bottom)
            
            // TODO: Add bottom inset for legacy devices
            
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }
        
    }
    
    static func alert(_ contentView: CardContentView) -> CardProtocol {
        
        return Card.build(contentView) { make in
            
            make.anchor = .center
            make.animator = AlertCardAnimator()
            make.corners.roundedCorners = .allCorners
            make.shadow = .default(for: .center)
            
            make.edges.setInsets(0)
            make.edges.setSafeAreaAvoidance(.none)
            
        }
        
    }

}
