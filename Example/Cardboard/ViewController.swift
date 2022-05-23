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
    
    weak var currentCard: Card?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.stackViewBottomConstraint.constant = UIDevice.current.isModern ? 0 : 20

    }
    
    @IBAction private func didTapDefault(_ sender: UIButton) {

        self.currentCard = Card
            .defaultModal(buildContentView()) { make in
                make.size.mode = .fixed(500)
            }
            .present(from: self)
        
    }
    
    @IBAction private func didTapSystem(_ sender: UIButton) {
        
        self.currentCard = Card
            .system(buildContentView()) { make in
                make.size.mode = .fixed(350)
            }
            .present(from: self)
        
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        
        let view = buildContentView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Notification"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        let messageLabel = UILabel()
        messageLabel.text = "Hello! This is an awesome notification brought to you by Cardboard! Looks kinda nice doesn't it? 😎"
        messageLabel.font = .preferredFont(forTextStyle: .body).withSize(14)
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        self.currentCard = Card
            .notification(view)
            .present(from: self)

    }
    
    @IBAction private func didTapBanner(_ sender: UIButton) {
        
        let view = buildContentView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Banner"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        let messageLabel = UILabel()
        messageLabel.text = "Hello! This is an awesome banner brought to you by Cardboard! Looks kinda nice doesn't it? 😎"
        messageLabel.font = .preferredFont(forTextStyle: .body).withSize(14)
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        self.currentCard = Card
            .banner(view)
            .present(from: self)

    }
    
    @IBAction private func didTapToast(_ sender: UIButton) {
        
        let view = buildContentView()
        
        let label = UILabel()
        label.text = "Hello! This is an awesome toast brought to you by Cardboard 😎"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        self.currentCard = Card
            .toast(view)
            .present(from: self)
        
    }
    
    @IBAction private func didTapAlert(_ sender: UIButton) {
        
        let width = (UIScreen.main.bounds.width - (12 * 2))
        let height = (width * 0.7)
        
        self.currentCard = Card
            .alert(buildContentView()) { make in
                
                make.size.mode = .fixedSize(.init(
                    width: width,
                    height: height
                ))
                
            }
            .present(from: self)
                
    }
    
    @IBAction private func didTapSheet(_ sender: UIButton) {
        
        let sheetView = SheetView.loadFromNib()
        
        self.currentCard = Card(sheetView) { make in
            
            make.contentOverlay = .color(.black.withAlphaComponent(0.4))
            make.isContentOverlayTapToDismissEnabled = false
            make.isSwipeToDismissEnabled = false
            
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setInset(12, for: .bottom, when: .safeArea(false))
            
        }
        .present(from: self)
        
    }
    
    @IBAction private func didTapCustom(_ sender: UIButton) {
              
        let view = buildContentView()
        view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        self.currentCard = Card.defaultModal(view) { make in
            
            make.animator = CustomCardAnimator()
            make.statusBar = .lightContent
            make.background = .blurred(style: .systemThinMaterial)
            make.corners.roundedCornerRadius = UIDevice.current.isModern ? UIScreen.main.cornerRadius : 24
            make.corners.roundedCorners = .allCorners
            make.isSwipeToDismissEnabled = false
            make.isContentOverlayTapToDismissEnabled = false
            
            make.edges.setInset(12, for: .top, when: .safeAreaLegacyStatusBar)
            make.edges.setInsets(12, for: [.left, .right])
            make.edges.setInset(12, for: .bottom, when: .safeArea(false))
            make.edges.setSafeAreaAvoidance(.card, for: [.top, .bottom])
            
        }
        .present(from: self)
                
    }
    
    @IBAction private func didTapDismiss(_ sender: UIButton) {
        self.currentCard?.dismiss()
    }
    
    private func buildContentView() -> CardContentView {
        
        let view = CardContentView()
        view.backgroundColor = .clear
        return view
        
    }
    
}

