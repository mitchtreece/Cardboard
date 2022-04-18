//
//  ViewController.swift
//  Cardboard
//
//  Created by Mitch Treece on 04/12/2022.
//  Copyright (c) 2022 Mitch Treece. All rights reserved.
//

import UIKit
import Cardboard

class ViewController: UIViewController {
    
    private var cardBackgroundStyle: Card.BackgroundStyle {
        return .color(.systemRed)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapSystem(_ sender: UIButton) {
        
        var card: Card = .system(contentView: contentView(height: 400))
        card.background = self.cardBackgroundStyle
        card.present(from: self)
        
    }
    
    @IBAction private func didTapDefaultTop(_ sender: UIButton) {

        var card: Card = .default(contentView: contentView(height: 500))
        card.anchor = .top
        card.background = self.cardBackgroundStyle
        card.present(from: self)
        
    }

    @IBAction private func didTapDefaultBottom(_ sender: UIButton) {
        
        var card: Card = .default(contentView: contentView(height: 500))
        card.background = self.cardBackgroundStyle
        card.present(from: self)
        
    }
    
    @IBAction private func didTapDefaultLeft(_ sender: UIButton) {

        let width = (UIScreen.main.bounds.width / 1.3)
        
        var card: Card = .default(contentView: contentView(width: width))
        card.anchor = .left
        card.background = self.cardBackgroundStyle
        card.present(from: self)
        
    }
    
    @IBAction private func didTapDefaultRight(_ sender: UIButton) {

        let width = (UIScreen.main.bounds.width / 1.3)
        
        var card: Card = .default(contentView: contentView(width: width))
        card.anchor = .right
        card.background = self.cardBackgroundStyle
        card.present(from: self)
        
    }
    
    @IBAction private func didTapAlert(_ sender: UIButton) {
        
        let width = (UIScreen.main.bounds.width - (12 * 2))
        let height = (width * 0.7)
        
        var card: Card = .alert(contentView: contentView(width: width, height: height))
        card.background = self.cardBackgroundStyle
        card.present(from: self)
        
    }

    @IBAction private func didTapNotification(_ sender: UIButton) {
        
        var card: Card = .notification(contentView: contentView(height: 100))
        card.background = self.cardBackgroundStyle
        card.duration = .none
        
        card.action = {
            print("Notification Tap!")
        }
        
        card.present(from: self)

    }
    
    @IBAction private func didTapToast(_ sender: UIButton) {
        
        var card: Card = .toast(contentView: contentView(height: 50))
        card.background = self.cardBackgroundStyle
        card.corners.roundedCornerRadius = 14
        card.duration = .none

        card.action = {
            print("Toast Tap!")
        }

        card.present(from: self)
        
    }
    
    private func contentView(width: CGFloat? = nil,
                             height: CGFloat? = nil) -> CardContentView {
        
        let view = CardContentView()
        view.backgroundColor = .white
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

