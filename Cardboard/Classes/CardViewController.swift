//
//  CardViewController.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit
import SnapKit

public class CardViewController: UIViewController {
    
    private var contentOverlayContentView: UIView!
    private var contentOverlayDimmingView: UIView?
    private var contentOverlayEffectView: UIVisualEffectView?
    
    private var cardView: CardView!
    private var cardContentContainerView: UIView!
    
    private var isCardBeingDismissed: Bool = false
    
    private let card: Card
    
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
    
    private var cardInsets: UIEdgeInsets {
        
        var insets = self.card.insets
        
        switch self.card.safeAreaAvoidance {
        case .card:
            
            let safeAreaInsets = self.safeAreaInsets
            
            insets.top += safeAreaInsets.top
            insets.left += safeAreaInsets.left
            insets.bottom += safeAreaInsets.bottom
            insets.right += safeAreaInsets.right
            
        default: break
        }
        
        return insets
        
    }
    
    private var contentInsets: UIEdgeInsets {
    
        var insets: UIEdgeInsets = .zero
        
        switch self.card.safeAreaAvoidance {
        case .content:
            
            let safeAreaInsets = self.safeAreaInsets
            
            switch self.card.anchor {
            case .top: insets.top += safeAreaInsets.top
            case .left: insets.left += safeAreaInsets.left
            case .bottom: insets.bottom += safeAreaInsets.bottom
            case .right: insets.right += safeAreaInsets.right
            case .none: break
            }
            
        default: break
        }
        
        return insets
        
    }
    
    private var hiddenCardAlpha: CGFloat {
        
        switch self.card.anchor {
        case .none: return 0
        default: return 1
        }
        
    }
    
    private var hiddenCardTransform: CGAffineTransform {
        
        var translation: CGPoint = .zero
        var scale: CGFloat = 1
        
        switch self.card.anchor {
        case .top:
            
            translation.y = -self.cardView.bounds.height
            translation.y -= self.cardInsets.top
            
        case .left:
            
            translation.x = -self.cardView.bounds.width
            translation.x -= self.cardInsets.left
            
        case .bottom:
            
            translation.y = self.cardView.bounds.height
            translation.y += self.cardInsets.bottom
            
        case .right:
            
            translation.x = self.cardView.bounds.width
            translation.x += self.cardInsets.right
            
        case .none:
            
            scale = 0.8
            
        }
        
        return CGAffineTransform(
            translationX: translation.x,
            y: translation.y
        )
        .scaledBy(x: scale, y: scale)
        
    }
    
    private var visibleCardTransform: CGAffineTransform {
        return .identity
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.card.statusBar
    }
    
    public override var prefersHomeIndicatorAutoHidden: Bool {
        return self.card.hidesHomeIndicator
    }
    
    public init(card: Card) {
        
        self.card = card
        
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.card.contentView.setup(in: self)
        
        self.view.isHidden = false // force viewDidLoad
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupSubviews()

        if self.card.isContentOverlayTapToDismissEnabled {

            self.contentOverlayContentView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(didTapContentOverlay(_:))
            ))

        }

        if self.card.isSwipeToDismissEnabled {

            self.cardView.addGestureRecognizer(UIPanGestureRecognizer(
                target: self,
                action: #selector(didPanCard(_:))
            ))

        }
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    private func setupSubviews() {
        
        // Content Overlay
        
        self.contentOverlayContentView = UIView()
        self.contentOverlayContentView.backgroundColor = .clear
        self.view.addSubview(self.contentOverlayContentView)
        self.contentOverlayContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        switch self.card.contentOverlay {
        case .color(let color):
            
            self.contentOverlayDimmingView = UIView()
            self.contentOverlayDimmingView!.backgroundColor = color
            self.contentOverlayDimmingView!.alpha = 0
            self.contentOverlayContentView.addSubview(self.contentOverlayDimmingView!)
            self.contentOverlayDimmingView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .blurred(let style):
            
            self.contentOverlayEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            self.contentOverlayEffectView!.alpha = 0
            self.contentOverlayContentView.addSubview(self.contentOverlayEffectView!)
            self.contentOverlayEffectView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        default: break
        }
        
        // Card
        
        self.cardView = CardView(card: self.card)
        self.view.addSubview(self.cardView)
        self.cardView.snp.makeConstraints { make in
            
            switch self.card.anchor {
            case .none:
                
                make.center.equalToSuperview()
                
            case .top:
                
                make.top.equalTo(self.cardInsets.top)
                make.left.equalTo(self.cardInsets.left)
                make.right.equalTo(-self.cardInsets.right)
                
            case .left:
                
                make.left.equalTo(self.cardInsets.left)
                make.top.equalTo(self.cardInsets.top)
                make.bottom.equalTo(-self.cardInsets.bottom)
                
            case .bottom:
                
                make.bottom.equalTo(-self.cardInsets.bottom)
                make.left.equalTo(self.cardInsets.left)
                make.right.equalTo(-self.cardInsets.right)
                
            case .right:
                
                make.right.equalTo(-self.cardInsets.right)
                make.top.equalTo(self.cardInsets.top)
                make.bottom.equalTo(-self.cardInsets.bottom)
                
            }

        }
        
        self.cardContentContainerView = UIView()
        self.cardContentContainerView.backgroundColor = .clear
        self.cardView.contentView.addSubview(self.cardContentContainerView)
        self.cardContentContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.contentInsets.top)
            make.left.equalTo(self.contentInsets.left)
            make.bottom.equalTo(-self.contentInsets.bottom)
            make.right.equalTo(-self.contentInsets.right)
        }
        
        self.cardContentContainerView.addSubview(self.card.contentView)
        self.card.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: Public
    
    func presentCard(from viewController: UIViewController,
                     completion: (()->())? = nil) {

        self.view.layoutIfNeeded()

        self.cardView.transform = self.hiddenCardTransform
        self.cardView.alpha = self.hiddenCardAlpha

        viewController.present(
            self,
            animated: false,
            completion: nil
        )
        
        self.card.willPresentAction?()

        DispatchQueue.main.async { [weak self] in
            
            self?.animateCard(open: true) {

                self?.card.didPresentAction?()
                completion?()

            }

        }
        
    }

    func dismissCard(completion: (()->())? = nil) {

        _dismissCard(
            reason: .default,
            velocity: nil,
            animated: true,
            completion: completion
        )
        
    }
    
    private func _dismissCard(reason: Card.DismissalReason,
                              velocity: CGFloat?,
                              animated: Bool,
                              completion: (()->())?) {
        
        self.isCardBeingDismissed = true
        
        self.card.willDismissAction?(reason)
        
        animateCard(
            open: false,
            velocity: velocity,
            animated: animated,
            completion: { [weak self] in
                
                self?.dismiss(
                    animated: false,
                    completion: {
                    
                        self?.card.didDismissAction?(reason)
                        completion?()
                        
                    })
                
            })
        
    }
    
    private func animateCard(open: Bool,
                             velocity: CGFloat? = nil,
                             animated: Bool = true,
                             completion: (()->())?) {
        
        // TODO: Velocity handling

        let duration = animated ? 0.3 : 0
        
        let animator = materialStandardAnimator(duration: duration)
        
        animator.addAnimations { [weak self] in
            
            guard let self = self else { return }
            
            self.contentOverlayDimmingView?.alpha = open ? 1 : 0
            self.contentOverlayEffectView?.alpha = open ? 1 : 0

            self.cardView.alpha = open ? 1 : self.hiddenCardAlpha
            
            self.cardView.transform = open ?
                self.visibleCardTransform :
                self.hiddenCardTransform

            self.setNeedsStatusBarAppearanceUpdate()
            
        }
        
        animator.addCompletion { _ in
            completion?()
        }
        
        animator.startAnimation()

    }
    
    @objc private func didTapContentOverlay(_ recognizer: UITapGestureRecognizer) {
        
        _dismissCard(
            reason: .interactive(.backgroundTap),
            velocity: nil,
            animated: true,
            completion: nil
        )
        
    }
    
    @objc private func didPanCard(_ recognizer: UIPanGestureRecognizer) {
        
        // TODO handle top & bottom anchored cards
        
        let yTranslation = recognizer.translation(in: self.view).y
        let velocity = recognizer.velocity(in: self.view)
        let cardHeight = self.cardView.bounds.height
        let progress = min(1, max(0, (yTranslation / cardHeight)))
                
        switch recognizer.state {
        case .changed:
            
            if yTranslation <= 0 {
                
                // Locked to max-height
                
                self.cardView.transform = .identity
                self.contentOverlayDimmingView?.alpha = 1
                self.contentOverlayEffectView?.alpha = 1
                
            }
            else if yTranslation > 0 && yTranslation < cardHeight {
                
                // Panning between max-height & min-height
                
                self.cardView.transform = CGAffineTransform(
                    translationX: 0,
                    y: yTranslation
                )
                
                self.contentOverlayDimmingView?.alpha = (1 - progress)
                self.contentOverlayEffectView?.alpha = (1 - progress)
                
            }
            else {
                                
                // Locked to min-height
                
                self.cardView.transform = CGAffineTransform(
                    translationX: 0,
                    y: cardHeight
                )
                
                self.contentOverlayDimmingView?.alpha = 0
                self.contentOverlayEffectView?.alpha = 0
                
            }
            
        case .ended, .cancelled, .failed:
            
            let translationThreshold = (cardHeight / 2)
            let velocityThreshold: CGFloat = 1000
            
            if yTranslation >= translationThreshold || velocity.y >= velocityThreshold {

                _dismissCard(
                    reason: .interactive(.swipe),
                    velocity: velocity.y,
                    animated: true,
                    completion: nil
                )
                                
            }
            else {
                
                animateCard(
                    open: true,
                    velocity: velocity.y,
                    completion: nil
                )

            }
            
        default: break
        }
        
    }
    
    private func materialStandardAnimator(duration: TimeInterval) -> UIViewPropertyAnimator {
        
        return UIViewPropertyAnimator(
            duration: duration,
            timingParameters: UICubicTimingParameters(
                controlPoint1: CGPoint(x: 0.4, y: 0),
                controlPoint2: CGPoint(x: 0.2, y: 1)
            ))
        
    }
    
}
