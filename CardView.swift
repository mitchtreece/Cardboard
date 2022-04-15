//
//  CardView.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/15/22.
//

import UIKit

internal class CardView: UIView {
    
    private let card: Card
    
    private(set) var contentView: UIView!
    private var effectView: UIVisualEffectView?
    
    private var contentMask: CAShapeLayer!
    private var shadowMask: CAShapeLayer!
    private var shadowLayer: CAShapeLayer!
    
    override var backgroundColor: UIColor? {
        get {
            return self.contentView?.backgroundColor
        }
        set {
            self.contentView?.backgroundColor = newValue
        }
    }

    init(card: Card) {
        
        self.card = card

        super.init(frame: .zero)
        
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        self.backgroundColor = .clear
        
        self.contentView = UIView()
        self.contentView.backgroundColor = .clear
        self.contentView.clipsToBounds = true
        addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentMask = CAShapeLayer()
        self.contentView.layer.mask = contentMask

        self.shadowMask = CAShapeLayer()
        self.shadowMask.fillRule = .evenOdd
        
        self.shadowLayer = CAShapeLayer()
        self.shadowLayer.masksToBounds = false
        self.shadowLayer.fillColor = UIColor.clear.cgColor
        self.shadowLayer.shadowColor = self.card.shadow.color.cgColor
        self.shadowLayer.shadowOffset = self.card.shadow.offset
        self.shadowLayer.shadowRadius = self.card.shadow.radius
        self.shadowLayer.shadowOpacity = Float(self.card.shadow.alpha)
        self.shadowLayer.mask = self.shadowMask
        self.layer.addSublayer(shadowLayer)
        
        switch self.card.background {
        case .none: self.backgroundColor = .clear
        case .color(let color): self.backgroundColor = color
        case .blurred(let style):

            self.effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            addSubview(self.effectView!)
            self.effectView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

        }
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let cornerStyle = self.card.corners
        let shadowStyle = self.card.shadow
        
        let cornerRadius = CGSize(
            width: cornerStyle.roundedCornerRadius,
            height: cornerStyle.roundedCornerRadius
        )
        
        let cornerRadiusPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: cornerStyle.roundedCorners,
            cornerRadii: cornerRadius
        )
                
        self.shadowLayer.frame = self.bounds
        self.shadowLayer.shadowPath = cornerRadiusPath.cgPath

        self.contentMask.frame = self.bounds
        self.contentMask.path = cornerRadiusPath.cgPath

        // Inner shadow mask
        
        let insets: CGFloat = (shadowStyle.radius * 2) + max(shadowStyle.offset.width, shadowStyle.offset.height)
        
        let shadowMaskPath = cornerRadiusPath
        shadowMaskPath.append(UIBezierPath(rect: bounds.insetBy(
            dx: -insets,
            dy: -insets
        )))

        self.shadowMask.path = shadowMaskPath.cgPath
        
    }
    
}
