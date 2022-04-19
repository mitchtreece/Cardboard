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
    
    @IBAction private func didTapDefault(_ sender: UIButton) {
        
        var card: Card = .default(contentView: contentView(height: 500))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapSystem(_ sender: UIButton) {
        
        let card: Card = .system(contentView: contentView(height: 400))
        card.present(from: self)
        
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        
        var card: Card = .notification(contentView: contentView(height: 100))

//        card.action = {
//            print("Notification Tap!")
//        }
        
        card.present(from: self)

    }
    
    @IBAction private func didTapToast(_ sender: UIButton) {
        
        var card: Card = .toast(contentView: contentView(height: 50))

//        card.action = {
//            print("Toast Tap!")
//        }

        card.present(from: self)
        
    }
    
    @IBAction private func didTapAlert(_ sender: UIButton) {
        
        let width = (UIScreen.main.bounds.width - (12 * 2))
        let height = (width * 0.7)
        
        let card: Card = .alert(contentView: contentView(width: width, height: height))
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

