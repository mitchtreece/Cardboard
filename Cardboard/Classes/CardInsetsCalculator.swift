//
//  CardInsetsCalculator.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/17/22.
//

import UIKit

internal struct CardInsetsCalculator {
    
    private let styleProvider: CardStyleProvider
    
    private var safeAreaInsets: UIEdgeInsets {
        
        return UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .safeAreaInsets ?? .zero
            
    }
    
    init(styleProvider: CardStyleProvider) {
        self.styleProvider = styleProvider
    }
    
    func cardInsets() -> UIEdgeInsets {
        
        var insets = UIEdgeInsets(
            top: self.styleProvider.edges.top.inset,
            left: self.styleProvider.edges.left.inset,
            bottom: self.styleProvider.edges.bottom.inset,
            right: self.styleProvider.edges.right.inset
        )
               
        for edge in self.styleProvider.edgesForAnchor {
            
            switch edge.safeAreaAvoidance {
            case .card:
                
                let inset = safeAreaInset(for: edge)
                
                insets = add(
                    value: inset,
                    to: insets,
                    for: edge
                )
                
            default: break
            }
            
        }
        
        return insets
        
    }
    
    func contentInsets() -> UIEdgeInsets {
        
        var insets: UIEdgeInsets = .zero
        
        for edge in self.styleProvider.edgesForAnchor {
            
            switch edge.safeAreaAvoidance {
            case .content:
                
                let inset = safeAreaInset(for: edge)
                
                insets = add(
                    value: inset,
                    to: insets,
                    for: edge
                )
                
            default: break
            }
            
        }
        
        return insets
        
    }
    
    // MARK: Private
    
    private func safeAreaInset(for edge: CardEdgeStyle.Edge) -> CGFloat {
        
        switch edge.type {
        case .top: return self.safeAreaInsets.top
        case .left: return self.safeAreaInsets.left
        case .bottom: return self.safeAreaInsets.bottom
        case .right: return self.safeAreaInsets.right
        }
        
    }
    
    private func add(value: CGFloat,
                     to insets: UIEdgeInsets,
                     for edge: CardEdgeStyle.Edge) -> UIEdgeInsets {
        
        var _insets = insets
        
        switch edge.type {
        case .top: _insets.top += value
        case .left: _insets.left += value
        case .bottom: _insets.bottom += value
        case .right: _insets.right += value
        }
        
        return _insets
        
    }
    
}
