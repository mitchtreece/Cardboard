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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapSystem(_ sender: UIButton) {
        
        let card: Card = .system(contentView: contentView(height: 300))
        card.present(from: self)
        
    }

    @IBAction private func didTapDefaultBottom(_ sender: UIButton) {
        
        let card: Card = .default(contentView: contentView(height: 400))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapDefaultTop(_ sender: UIButton) {

        var card: Card = .default(contentView: contentView(height: 400))
        card.anchor = .top
        card.present(from: self)
        
    }
    
    @IBAction private func didTapAlert(_ sender: UIButton) {
        
        let card: Card = .alert(contentView: contentView(width: 300, height: 300))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        
        let card: Card = .notification(contentView: contentView(height: 100))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapToast(_ sender: UIButton) {
        
        let card: Card = .toast(contentView: contentView(height: 64))
        card.present(from: self)
        
    }
    
    private func contentView(width: CGFloat? = 0,
                             height: CGFloat? = 0,
                             color: UIColor = .clear) -> CardContentView {
        
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

