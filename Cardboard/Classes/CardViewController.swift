//
//  CardViewController.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit
import SnapKit

internal class CardViewController: UIViewController {
    
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
    
    private let contentView: CardContentView
    private let styleProvider: CardStyleProvider
    private let actionProvider: CardActionProvider
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.styleProvider.statusBar
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.styleProvider.hidesHomeIndicator
    }
        
    init(contentView: CardContentView,
         styleProvider: CardStyleProvider,
         actionProvider: CardActionProvider) {
        
        self.contentView = contentView
        self.styleProvider = styleProvider
        self.actionProvider = actionProvider
        
        self.insetsCalculator = CardInsetsCalculator(styleProvider: styleProvider)
        
        super.init(
            nibName: nil,
            bundle: nil
        )
                
        self.view.isHidden = false // force viewDidLoad
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupSubviews()

        if self.styleProvider.isContentOverlayTapToDismissEnabled {

            self.contentOverlayContentView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(didTapContentOverlay(_:))
            ))

        }

        if self.styleProvider.isSwipeToDismissEnabled {

            self.swipeRecognizer = UIPanGestureRecognizer(
                target: self,
                action: #selector(didPanCard(_:))
            )
            
            self.swipeRecognizer!.delegate = self
            self.cardView.addGestureRecognizer(self.swipeRecognizer!)

        }
        
//        if let _ = self.actionProvider.action {
//
//            self.actionRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapCard(_:)))
//            self.actionRecognizer!.minimumPressDuration = 0.01
//            self.actionRecognizer!.delegate = self
//            self.cardView.addGestureRecognizer(self.actionRecognizer!)
//
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        switch self.styleProvider.contentOverlay {
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
        
        self.cardView = CardView(styleProvider: self.styleProvider)
        self.view.addSubview(self.cardView)
        self.cardView.snp.makeConstraints { make in
            
            switch self.styleProvider.anchor {
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
        
        self.cardContentContainerView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: Public
    
    func presentCard(from viewController: UIViewController) {
        
        self.sourceViewController = viewController
        
        self.view.layoutIfNeeded()

        self.styleProvider.animator
            .setup(ctx: animationContext(animation: .presentation))

        viewController.present(
            self,
            animated: false,
            completion: nil
        )
        
        self.actionProvider.willPresentAction?()

        DispatchQueue.main.async { [weak self] in
            
            self?.animateCard(presentation: true) {

                self?.startDismissTimerIfNeeded()
                self?.actionProvider.didPresentAction?()

            }

        }
        
    }

    func dismissCard() {

        _dismissCard(
            reason: .default,
            velocity: nil,
            animated: true,
            completion: nil
        )
        
    }
    
    // MARK: Private
    
    private func animationContext(animation: CardAnimator.Animation) -> CardAnimator.Context {
        
        return CardAnimator.Context(
            sourceView: self.sourceViewController!.view,
            containerView: self.containerView,
            contentOverlayView: self.contentOverlayContentView,
            cardView: self.cardView,
            anchor: self.styleProvider.anchor,
            insets: self.insetsCalculator.cardInsets(),
            animation: animation
        )
        
    }
    
    private func _dismissCard(reason: Card.DismissalReason,
                              velocity: CGFloat?,
                              animated: Bool,
                              completion: (()->())?) {
        
        self.isCardBeingDismissed = true
        
        self.actionProvider
            .willDismissAction?(reason)
        
        animateCard(
            presentation: false,
            velocity: velocity,
            animated: animated,
            completion: { [weak self] in
                
                self?.dismiss(
                    animated: false,
                    completion: {
                    
                        self?.actionProvider
                            .didDismissAction?(reason)
                        
                        completion?()
                        
                    })
                
            })
        
    }
    
    private func animateCard(presentation: Bool,
                             velocity: CGFloat? = nil,
                             animated: Bool = true,
                             completion: (()->())?) {
        
        // TODO: Velocity handling

        let animator = self.styleProvider.animator
        let viewAnimtor = self.styleProvider.animator.animator!
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

//                _dismissCard(
//                    reason: .default,
//                    velocity: nil,
//                    animated: true,
//                    completion: { [weak self] in
//                        self?.actionProvider.action?()
//                    })
                
                dismissCard()
                
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
        
        let translation = recognizer.translation(in: self.containerView)
        let alertTranslation = CGPoint(x: translation.x * 0.1, y: translation.y * 0.1)
        let velocity = recognizer.velocity(in: self.containerView)
        let cardSize = self.cardView.bounds.size

        let progress = CGPoint(
            x: min(1, max(0, (abs(translation.x) / cardSize.width))),
            y: min(1, max(0, (abs(translation.y) / cardSize.height)))
        )
                
        switch recognizer.state {
        case .changed:
            
            var cardTransform: CGAffineTransform = .identity
            var backgroundAlpha: CGFloat = 1
            
            switch self.styleProvider.anchor {
            case .top:
                
                if translation.y >= 0 {
                    
                    // open
                    
                    cardTransform = .identity
                    backgroundAlpha = 1
                    
                }
                else if translation.y < 0 && translation.y > -cardSize.height {
                    
                    // panning
                    
                    cardTransform = CGAffineTransform(
                        translationX: 0,
                        y: translation.y
                    )

                    backgroundAlpha = (1 - progress.y)
                    
                }
                else {
                    
                    // closed
                    
                    cardTransform = CGAffineTransform(
                        translationX: 0,
                        y: cardSize.height
                    )

                    backgroundAlpha = 0
                    
                }
                
            case .left:
                
                if translation.x >= 0 {
                    
                    // open
                    
                    cardTransform = .identity
                    backgroundAlpha = 1
                    
                }
                else if translation.x < 0 && translation.x > -cardSize.width {
                    
                    // panning
                    
                    cardTransform = CGAffineTransform(
                        translationX: translation.x,
                        y: 0
                    )

                    backgroundAlpha = (1 - progress.x)
                    
                }
                else {
                    
                    // closed
                    
                    cardTransform = CGAffineTransform(
                        translationX: cardSize.width,
                        y: 0
                    )

                    backgroundAlpha = 0
                    
                }
                
            case .bottom:
                
                if translation.y <= 0 {
                    
                    // open
                    
                    cardTransform = .identity
                    backgroundAlpha = 1
                    
                }
                else if translation.y > 0 && translation.y < cardSize.height {
                    
                    // panning
                    
                    cardTransform = CGAffineTransform(
                        translationX: 0,
                        y: translation.y
                    )

                    backgroundAlpha = (1 - progress.y)
                    
                }
                else {
                    
                    // closed
                    
                    cardTransform = CGAffineTransform(
                        translationX: 0,
                        y: cardSize.height
                    )

                    backgroundAlpha = 0
                    
                }
                
            case .right:
                
                if translation.x <= 0 {
                    
                    // open
                    
                    cardTransform = .identity
                    backgroundAlpha = 1
                    
                }
                else if translation.x > 0 && translation.x < cardSize.width {
                    
                    // panning
                    
                    cardTransform = CGAffineTransform(
                        translationX: translation.x,
                        y: 0
                    )

                    backgroundAlpha = (1 - progress.x)
                    
                }
                else {
                
                    // closed
                    
                    cardTransform = CGAffineTransform(
                        translationX: cardSize.width,
                        y: 0
                    )

                    backgroundAlpha = 0
                    
                }
                
            case .center:
                
                cardTransform = CGAffineTransform(
                    translationX: alertTranslation.x,
                    y: alertTranslation.y
                )
                                
            }
            
            self.cardView.transform = cardTransform
            self.contentOverlayContentView.alpha = backgroundAlpha
            
        case .ended, .cancelled, .failed:
            
            let velocityThreshold: CGFloat = 1000
            var shouldDismissCard: Bool = false
            
            switch self.styleProvider.anchor {
            case .top:
                
                let translationThreshold = (cardSize.height / 2)
                
                if translation.y <= -translationThreshold || velocity.y <= -velocityThreshold {
                    shouldDismissCard = true
                }
                
            case .bottom:
                
                let translationThreshold = (cardSize.height / 2)
                
                if translation.y >= translationThreshold || velocity.y >= velocityThreshold {
                    shouldDismissCard = true
                }
                
            case .left:
                
                let translationThreshold = (cardSize.width / 2)
                
                if translation.x <= -translationThreshold || velocity.x <= -velocityThreshold {
                    shouldDismissCard = true
                }
                
            case .right:
                
                let translationThreshold = (cardSize.width / 2)
                
                if translation.x >= translationThreshold || velocity.x >= velocityThreshold {
                    shouldDismissCard = true
                }
                
            case .center:
                
                let translationThreshold: CGFloat = 20
                let maxTranslation = max(abs(alertTranslation.x), abs(alertTranslation.y))
                let maxVelocity = max(abs(velocity.x), abs(velocity.y))
                
                if maxTranslation >= translationThreshold || maxVelocity >= velocityThreshold {
                    shouldDismissCard = true
                }
                
            }
            
            if shouldDismissCard {

                _dismissCard(
                    reason: .interactive(.swipe),
                    velocity: velocity.y,
                    animated: true,
                    completion: nil
                )

            }
            else {

                animateCard(
                    presentation: true,
                    velocity: velocity.y,
                    completion: nil
                )

            }
            
        default: break
        }
        
    }
    
    private func startDismissTimerIfNeeded() {
        
        switch self.styleProvider.duration {
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
