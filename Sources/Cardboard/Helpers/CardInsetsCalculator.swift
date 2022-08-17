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
    
    private let legacyStatusBarHeight: CGFloat = 20
    
    init(styleProvider: CardStyleProvider) {
        self.styleProvider = styleProvider
    }
    
    func cardInsets() -> UIEdgeInsets {
        
        // Insets
        
        var insets: UIEdgeInsets = .zero
        
        func setInsetValue(for edge: CardEdges.Edge) {
            
            switch edge.type {
            case .top: insets.top = edge.inset
            case .left: insets.left = edge.inset
            case .bottom: insets.bottom = edge.inset
            case .right: insets.right = edge.inset
            }
            
        }
        
        for edge in self.styleProvider.edges.all {
                        
            switch edge.insetCondition {
            case .always: setInsetValue(for: edge)
            case .safeArea(let safeArea):
                
                let safeAreaInset = safeAreaInset(for: edge)
                
                if safeArea && safeAreaInset != 0 {
                    setInsetValue(for: edge)
                }
                else if !safeArea && safeAreaInset == 0 {
                    setInsetValue(for: edge)
                }
                
            case .safeAreaLegacyStatusBar:
                
                let safeAreaInset = safeAreaInset(for: edge)
                
                if safeAreaInset == self.legacyStatusBarHeight {
                    setInsetValue(for: edge)
                }
                
            case .custom(let condition):
                
                if condition() {
                    setInsetValue(for: edge)
                }
                
            }
            
        }
        
        // Safe Area Avoidance
               
        for edge in self.styleProvider.edgesForAnchor {
            
            switch edge.safeAreaAvoidance {
            case .card:
                
                insets = add(
                    value: safeAreaInset(for: edge),
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
        
        // Safe Area Avoidance
        
        for edge in self.styleProvider.edgesForAnchor {
            
            switch edge.safeAreaAvoidance {
            case .content:
                                
                insets = add(
                    value: safeAreaInset(for: edge),
                    to: insets,
                    for: edge
                )
                
            default: break
            }
            
        }
        
        return insets
        
    }
    
    // MARK: Private
    
    private func safeAreaInset(for edge: CardEdges.Edge) -> CGFloat {
        
        switch edge.type {
        case .top: return self.safeAreaInsets.top
        case .left: return self.safeAreaInsets.left
        case .bottom: return self.safeAreaInsets.bottom
        case .right: return self.safeAreaInsets.right
        }
        
    }
    
    private func add(value: CGFloat,
                     to insets: UIEdgeInsets,
                     for edge: CardEdges.Edge) -> UIEdgeInsets {
        
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
