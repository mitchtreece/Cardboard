//
//  CardViewController.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit
import SnapKit

public class CardViewController: UIViewController {
    
    private var containerView: UIView!
    private var contentOverlayContentView: UIView!
    private var contentOverlayDimmingView: UIView?
    private var contentOverlayEffectView: UIVisualEffectView?
    private var cardView: CardView!
    private var cardContentContainerView: UIView!
    
    private weak var sourceViewController: UIViewController?
    private var swipeRecognizer: UIPanGestureRecognizer?
    private var actionRecognizer: UILongPressGestureRecognizer?
    private var dismissTimer: Timer?
    private var insetsCalculator: CardInsetsCalculator!
    
    private var isCardBeingDismissed: Bool = false
    
    private let card: Card
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.card.statusBar
    }
    
    public override var prefersHomeIndicatorAutoHidden: Bool {
        return self.card.hidesHomeIndicator
    }
        
    public init(card: Card) {
        
        self.card = card
        self.insetsCalculator = CardInsetsCalculator(card: card)
        
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

            self.swipeRecognizer = UIPanGestureRecognizer(
                target: self,
                action: #selector(didPanCard(_:))
            )
            
            self.swipeRecognizer!.delegate = self
            self.cardView.addGestureRecognizer(self.swipeRecognizer!)

        }
        
        if let _ = self.card.action {
            
            self.actionRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapCard(_:)))
            self.actionRecognizer!.minimumPressDuration = 0.01
            self.actionRecognizer!.delegate = self
            self.cardView.addGestureRecognizer(self.actionRecognizer!)
            
        }

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    private func setupSubviews() {
        
        // Container
        
        self.containerView = UIView()
        self.containerView.backgroundColor = .clear
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Content Overlay
        
        self.contentOverlayContentView = UIView()
        self.contentOverlayContentView.backgroundColor = .clear
        self.containerView.addSubview(self.contentOverlayContentView)
        self.contentOverlayContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        switch self.card.contentOverlay {
        case .color(let color):
            
            self.contentOverlayDimmingView = UIView()
            self.contentOverlayDimmingView!.backgroundColor = color
            self.contentOverlayContentView.addSubview(self.contentOverlayDimmingView!)
            self.contentOverlayDimmingView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .blurred(let style):
            
            self.contentOverlayEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            self.contentOverlayContentView.addSubview(self.contentOverlayEffectView!)
            self.contentOverlayEffectView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        default: break
        }
        
        // Card
        
        let cardInsets = self.insetsCalculator.cardInsets()
        let contentInsets = self.insetsCalculator.contentInsets()
        
        self.cardView = CardView(card: self.card)
        self.view.addSubview(self.cardView)
        self.cardView.snp.makeConstraints { make in
            
            switch self.card.anchor {
            case .top:
                
                make.top.equalTo(cardInsets.top)
                make.left.equalTo(cardInsets.left)
                make.right.equalTo(-cardInsets.right)
                
            case .left:
                
                make.left.equalTo(cardInsets.left)
                make.top.equalTo(cardInsets.top)
                make.bottom.equalTo(-cardInsets.bottom)
                
            case .bottom:
                
                make.bottom.equalTo(-cardInsets.bottom)
                make.left.equalTo(cardInsets.left)
                make.right.equalTo(-cardInsets.right)
                
            case .right:
                
                make.right.equalTo(-cardInsets.right)
                make.top.equalTo(cardInsets.top)
                make.bottom.equalTo(-cardInsets.bottom)

            case .center: make.center.equalToSuperview()
            }

        }
        
        self.cardContentContainerView = UIView()
        self.cardContentContainerView.backgroundColor = .clear
        self.cardView.contentView.addSubview(self.cardContentContainerView)
        self.cardContentContainerView.snp.makeConstraints { make in
            make.top.equalTo(contentInsets.top)
            make.left.equalTo(contentInsets.left)
            make.bottom.equalTo(-contentInsets.bottom)
            make.right.equalTo(-contentInsets.right)
        }
        
        self.cardContentContainerView.addSubview(self.card.contentView)
        self.card.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: Public
    
    func presentCard(from viewController: UIViewController,
                     completion: (()->())? = nil) {
        
        self.sourceViewController = viewController
        
        self.view.layoutIfNeeded()

        self.card.animator
            .setup(ctx: animationContext(animation: .presentation))

        viewController.present(
            self,
            animated: false,
            completion: nil
        )
        
        self.card.willPresentAction?()

        DispatchQueue.main.async { [weak self] in
            
            self?.animateCard(presentation: true) {

                self?.startDismissTimerIfNeeded()
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
    
    // MARK: Private
    
    private func animationContext(animation: CardAnimator.Animation) -> CardAnimator.Context {
        
        return CardAnimator.Context(
            sourceView: self.sourceViewController!.view,
            containerView: self.containerView,
            contentOverlayView: self.contentOverlayContentView,
            cardView: self.cardView,
            anchor: self.card.anchor,
            insets: self.insetsCalculator.cardInsets(),
            animation: animation
        )
        
    }
    
    private func _dismissCard(reason: Card.DismissalReason,
                              velocity: CGFloat?,
                              animated: Bool,
                              completion: (()->())?) {
        
        self.isCardBeingDismissed = true
        
        self.card.willDismissAction?(reason)
        
        animateCard(
            presentation: false,
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
    
    private func animateCard(presentation: Bool,
                             velocity: CGFloat? = nil,
                             animated: Bool = true,
                             completion: (()->())?) {
        
        // TODO: Velocity handling

        let animator = self.card.animator
        let viewAnimtor = self.card.animator.animator!
        let context = animationContext(animation: presentation ? .presentation : .dismissal)
        
        viewAnimtor.addAnimations { [weak self] in
            
            guard let self = self else { return }
                        
            animator.animate(ctx: context)
            
            self.setNeedsStatusBarAppearanceUpdate()
            
        }
        
        viewAnimtor.addCompletion { _ in
            
            animator.cleanup(ctx: context)
            completion?()
            
        }
        
        viewAnimtor.startAnimation()

    }
    
    @objc private func didTapContentOverlay(_ recognizer: UITapGestureRecognizer) {
        
        _dismissCard(
            reason: .interactive(.background),
            velocity: nil,
            animated: true,
            completion: nil
        )
        
    }
    
    @objc private func didTapCard(_ recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            
            print("began")
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                self.cardView.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: nil)

        case .ended:
            
            
            let location = recognizer.location(in: self.cardView)
            let isLocationInCard = self.cardView.bounds.contains(location)
            
            print("ended, inside card?: \(isLocationInCard)")

            if isLocationInCard {
                
                dismissCard { [weak self] in
                    self?.card.action?()
                }
                
            }
            else {
                
                UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                    self.cardView.transform = .identity
                }, completion: nil)
                
            }
            
        case .cancelled, .failed:
            
            print("cancel fail")
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                self.cardView.transform = .identity
            }, completion: nil)
            
        default: break
        }
        
    }
    
    @objc private func didPanCard(_ recognizer: UIPanGestureRecognizer) {
        
//        // TODO handle top & bottom anchored cards
//
//        let yTranslation = recognizer.translation(in: self.view).y
//        let velocity = recognizer.velocity(in: self.view)
//        let cardHeight = self.cardView.bounds.height
//        let progress = min(1, max(0, (yTranslation / cardHeight)))
//
//        switch recognizer.state {
//        case .changed:
//
//            if yTranslation <= 0 {
//
//                // Locked to max-height
//
//                self.cardView.transform = .identity
//                self.contentOverlayDimmingView?.alpha = 1
//                self.contentOverlayEffectView?.alpha = 1
//
//            }
//            else if yTranslation > 0 && yTranslation < cardHeight {
//
//                // Panning between max-height & min-height
//
//                self.cardView.transform = CGAffineTransform(
//                    translationX: 0,
//                    y: yTranslation
//                )
//
//                self.contentOverlayDimmingView?.alpha = (1 - progress)
//                self.contentOverlayEffectView?.alpha = (1 - progress)
//
//            }
//            else {
//
//                // Locked to min-height
//
//                self.cardView.transform = CGAffineTransform(
//                    translationX: 0,
//                    y: cardHeight
//                )
//
//                self.contentOverlayDimmingView?.alpha = 0
//                self.contentOverlayEffectView?.alpha = 0
//
//            }
//
//        case .ended, .cancelled, .failed:
//
//            let translationThreshold = (cardHeight / 2)
//            let velocityThreshold: CGFloat = 1000
//
//            if yTranslation >= translationThreshold || velocity.y >= velocityThreshold {
//
//                _dismissCard(
//                    reason: .interactive(.swipe),
//                    velocity: velocity.y,
//                    animated: true,
//                    completion: nil
//                )
//
//            }
//            else {
//
//                animateCard(
//                    presentation: true,
//                    velocity: velocity.y,
//                    completion: nil
//                )
//
//            }
//
//        default: break
//        }
        
    }
    
    private func startDismissTimerIfNeeded() {
        
        switch self.card.duration {
        case .seconds(let duration):
            
            self.dismissTimer = Timer.scheduledTimer(withTimeInterval: duration,
                                                     repeats: false,
                                                     block: { [weak self] _ in
                
                self?.dismissCard()
                
            })
            
        default: break
        }
        
    }
    
}

extension CardViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
