//
//  SheetView.swift
//  Demo
//
//  Created by Mitch Treece on 4/14/23.
//

import UIKit
import Cardboard
import EspressoUI

class SheetView: CardContentView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var okayButtonContentView: UIView!
    @IBOutlet private weak var cancelButtonContentView: UIView!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupSubviews()
        setupRecognizers()

    }
    
    private func setupSubviews() {
        
        self.backgroundColor = .clear
        
        self.contentView.roundCorners(radius: 16)
        self.okayButtonContentView.roundCorners(radius: 10)
        self.cancelButtonContentView.roundCorners(radius: 10)
        
    }
    
    private func setupRecognizers() {
        
        self.okayButtonContentView.addTapGesture { [weak self] _ in
            self?.okay()
        }
        
        self.cancelButtonContentView.addTapGesture { [weak self] _ in
            self?.cancel()
        }
        
    }
    
    private func okay() {
        
        print("Okay")
        self.card?.dismiss()
        
    }
    
    private func cancel() {
        
        print("Cancel")
        self.card?.dismiss()
        
    }
    
}
