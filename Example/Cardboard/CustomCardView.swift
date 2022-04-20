//
//  CustomCardView.swift
//  Cardboard_Example
//
//  Created by Mitch Treece on 4/19/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Cardboard

class CustomCardView: CardContentView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setupSubviews()
        
    }
    
    private func setupSubviews() {
        
        self.backgroundColor = .clear
        
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Done", for: .normal)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.bottom.equalTo(-32)
            make.right.equalTo(-32)
            make.height.equalTo(44)
        }
        
        button.addTarget(
            self,
            action: #selector(didTapButton(_:)),
            for: .touchUpInside
        )
        
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        self.card.dismiss()
    }
    
}
