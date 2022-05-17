//
//  ViewController.swift
//  Cardboard
//
//  Created by Mitch Treece on 04/12/2022.
//  Copyright (c) 2022 Mitch Treece. All rights reserved.
//

import UIKit
import Espresso
import Cardboard

class ViewController: UIViewController {
    
    @IBOutlet private weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.stackViewBottomConstraint.constant = UIDevice.current.isModern ? 0 : 20
        
    }
    
    @IBAction private func didTapDefault(_ sender: UIButton) {

        Card
            .defaultModal(contentView(height: 500))
            .present(from: self)
        
    }
    
    @IBAction private func didTapSystem(_ sender: UIButton) {
        
        Card
            .system(contentView(height: 350))
            .present(from: self)
        
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        
        Card
            .notification(contentView(
                height: 100,
                color: .systemPink
            ))
            .present(from: self)

    }
    
    @IBAction private func didTapBanner(_ sender: UIButton) {
        
        Card
            .banner(contentView(
                
                height: 100,
                color: .clear
                
            )) { make in
                
                make.background = .color(.systemPink)
                
            }
            .present(from: self)

    }
    
    @IBAction private func didTapToast(_ sender: UIButton) {
        
        Card
            .toast(contentView(height: 64, color: .systemPink))
            .present(from: self)
        
    }
    
    @IBAction private func didTapAlert(_ sender: UIButton) {
        
        let width = (UIScreen.main.bounds.width - (12 * 2))
        let height = (width * 0.7)
        
        Card
            .alert(contentView(
                width: width,
                height: height
            ))
            .present(from: self)
                
    }
    
    @IBAction private func didTapSheet(_ sender: UIButton) {
        
        let sheetView = SheetView.loadFromNib()
        
        Card(sheetView) { make in
            
            make.contentOverlay = .color(.black.withAlphaComponent(0.4))
            make.edges.setInsets(12, for: [.left, .right])
            make.isContentOverlayTapToDismissEnabled = false
            make.isSwipeToDismissEnabled = false
            
        }
        .present(from: self)
        
    }
    
    @IBAction private func didTapCustom(_ sender: UIButton) {
              
        let view = CustomCardView()
        view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        Card.defaultModal(view) { make in
            
            make.anchor = .bottom
            make.contentOverlay = .blurred(style: .systemThinMaterialDark)
            make.background = .blurred(style: .systemUltraThinMaterialLight)
            make.statusBar = .lightContent
            make.corners.roundedCornerRadius = 44
            make.corners.roundedCorners = .allCorners
            make.edges.setInsets(18, for: [.left, .right])
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }
        .present(from: self)
                
    }
    
    private func contentView(width: CGFloat? = nil,
                             height: CGFloat? = nil,
                             color: UIColor = .white) -> CardContentView {
        
        let view = CardContentView()
        view.backgroundColor = color
        view.snp.makeConstraints { make in
            
            if let w = width {
                make.width.equalTo(w)
            }
            
            if let h = height {
                make.height.equalTo(h)
            }
            
        }
        
        return view
        
    }
    
}

