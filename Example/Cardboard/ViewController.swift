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

        let card = Card.default(contentView(height: 500))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapSystem(_ sender: UIButton) {
        
        let card = Card.system(contentView(height: 350))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        
        let card = Card.notification(contentView(height: 100))

//        card.action = {
//            print("Notification Tap!")
//        }
        
        card.present(from: self)

    }
    
    @IBAction private func didTapToast(_ sender: UIButton) {
        
        let card = Card.toast(contentView(height: 50))

//        card.action = {
//            print("Toast Tap!")
//        }

        card.present(from: self)
        
    }
    
    @IBAction private func didTapAlert(_ sender: UIButton) {
        
        let width = (UIScreen.main.bounds.width - (12 * 2))
        let height = (width * 0.7)
        
        let card = Card.alert(contentView(
            width: width,
            height: height
        ))
        
        card.present(from: self)
        
    }
    
    @IBAction private func didTapSheet(_ sender: UIButton) {
        
        // TODO
        
    }
    
    @IBAction private func didTapCustom(_ sender: UIButton) {
              
        let view = CustomCardView()
        view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        var builder = Card
            .default(view)
            .asBuilder()

        builder.anchor = .bottom
        builder.contentOverlay = .blurred(style: .systemThinMaterialDark)
        builder.background = .blurred(style: .systemUltraThinMaterialLight)
        builder.statusBar = .lightContent
        builder.corners.roundedCornerRadius = 64
        builder.corners.roundedCorners = .allCorners
        builder.edges.setInsets(18, for: [.left, .right])
        builder.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
        
        Card.build(builder)
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

