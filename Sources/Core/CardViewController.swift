//
//  CardViewController.swift
//  Cardboard
//
//  Created by Mitch Treece on 4/12/22.
//

import UIKit
import SnapKit

internal class CardViewController: UIViewController {
    
    private var containerView: TouchThroughView!
    private var contentOverlayContentView: TouchThroughView!
    private var contentOverlayDimmingView: UIView?
    private var contentOverlayEffectView: UIVisualEffectView?
    private var cardView: CardView!
    private var cardContentContainerView: UIView!
    private var cardAnchorOverflowView: UIView?
    
    private weak var sourceViewController: UIViewController?
    private var swipeRecognizer: UIPanGestureRecognizer?
    private var actionRecognizer: UILongPressGestureRecognizer?
    private var dismissTimer: Timer?
    private var insetsCalculator: CardInsetsCalculator!
    
    private var isCardBeingPanned: Bool = false
    private var isCardBeingDismissed: Bool = false
    
    private let contentView: CardContentView
    private let styleProvider: CardStyleProvider
    private let actionProvider: CardActionProvider
    
    private let cardConstraintPriority: Int = 999
        
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

    override func loadView() {
        self.view = TouchForwardingView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSubviews()
        setupInteractions()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
                
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if let touchForwardindView = self.view as? TouchForwardingView {
            touchForwardindView.touchForwardedView = self.presentingViewController?.view
        }
                
    }
    
    private func setupSubviews() {
        
        // Container
        
        self.containerView = TouchThroughView()
        self.containerView.backgroundColor = .clear
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Content Overlay
        
        self.contentOverlayContentView = TouchThroughView()
        self.contentOverlayContentView.backgroundColor = .clear
        self.contentOverlayContentView.isTouchThroughEnabled = false
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
        self.containerView.addSubview(self.cardView)
        self.cardView.snp.makeConstraints { make in
            
            switch self.styleProvider.anchor {
            case .top:
                
                make.top
                    .equalTo(cardInsets.top)
                    .priority(self.cardConstraintPriority)
                
                make.left
                    .equalTo(cardInsets.left)
                    .priority(self.cardConstraintPriority)
                
                make.right
                    .equalTo(-cardInsets.right)
                    .priority(self.cardConstraintPriority)
                
            case .left:
                
                make.left
                    .equalTo(cardInsets.left)
                    .priority(self.cardConstraintPriority)
                
                make.top
                    .equalTo(cardInsets.top)
                    .priority(self.cardConstraintPriority)
                
                make.bottom
                    .equalTo(-cardInsets.bottom)
                    .priority(self.cardConstraintPriority)
                
            case .bottom:
                
                make.bottom
                    .equalTo(-cardInsets.bottom)
                    .priority(self.cardConstraintPriority)
                
                make.left
                    .equalTo(cardInsets.left)
                    .priority(self.cardConstraintPriority)
                
                make.right
                    .equalTo(-cardInsets.right)
                    .priority(self.cardConstraintPriority)
                
            case .right:
                
                make.right
                    .equalTo(-cardInsets.right)
                    .priority(self.cardConstraintPriority)
                
                make.top
                    .equalTo(cardInsets.top)
                    .priority(self.cardConstraintPriority)
                
                make.bottom
                    .equalTo(-cardInsets.bottom)
                    .priority(self.cardConstraintPriority)

            case .center:
                
                make.center
                    .equalToSuperview()
                
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
            
            switch self.styleProvider.size.mode {
            case .content: make.edges.equalToSuperview()
            case .fixed(let value):
                
                make.edges.equalToSuperview()
                
                switch self.styleProvider.anchor {
                case .top, .bottom: make.height.equalTo(value)
                case .left, .right: make.width.equalTo(value)
                case .center:
                    
                    make.width.equalTo(value)
                    make.height.equalTo(value)
                    
                }
                
            case .fixedSize(let size):
                
                make.edges.equalToSuperview()
                
                switch self.styleProvider.anchor {
                case .top, .bottom: make.height.equalTo(size.height)
                case .left, .right: make.width.equalTo(size.width)
                case .center: make.size.equalTo(size)
                }
                
            }
            
        }
        
    }
    
    private func setupInteractions() {
                
        if self.styleProvider.isContentOverlayTapToDismissEnabled {

            self.contentOverlayContentView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(didTapContentOverlay(_:))
            ))

        }
        else if self.styleProvider.isContentOverlayTouchThroughEnabled {
            
            self.contentOverlayContentView.isTouchThroughEnabled = true
            self.contentOverlayDimmingView?.isUserInteractionEnabled = false
            self.contentOverlayEffectView?.isUserInteractionEnabled = false
            
        }

        if self.styleProvider.isSwipeToDismissEnabled {

            self.swipeRecognizer = UIPanGestureRecognizer(
                target: self,
                action: #selector(didPanCard(_:))
            )
            
            self.swipeRecognizer!.delegate = self
            self.cardView.addGestureRecognizer(self.swipeRecognizer!)

        }
                
    }
    
    // MARK: Public
    
    func presentCard(from viewController: UIViewController) {
        
        let present = {
            
            self.sourceViewController = viewController
            
            self.view.layoutIfNeeded()

            self.styleProvider
                .animator
                .setup(ctx: self.animationContext(animation: .presentation))

            viewController.present(
                self,
                animated: false,
                completion: nil
            )
            
            self.actionProvider
                .willPresentAction?()

            DispatchQueue.main.async { [weak self] in
                
                self?.animateCard(presentation: true) {

                    self?.startDismissTimerIfNeeded()
                    
                    self?.actionProvider
                        .didPresentAction?()

                }

            }
            
        }
        
        if let currentCardViewController = viewController.presentedViewController as? CardViewController,
           self.styleProvider.dismissesCurrentCardsInContext {
            
            currentCardViewController._dismissCard(
                reason: .default,
                velocity: nil,
                animated: true,
                completion: {
                    present()
                })
            
            return
            
        }

        present()
        
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
            animation: animation,
            sourceView: self.sourceViewController!.view,
            containerView: self.containerView,
            contentOverlayView: self.contentOverlayContentView,
            cardView: self.cardView,
            anchor: self.styleProvider.anchor,
            insets: self.insetsCalculator.cardInsets()
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
        case .began: self.isCardBeingPanned = true
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
            
            self.isCardBeingPanned = false
            
        default: break
        }
        
    }
    
    private func startDismissTimerIfNeeded() {
        
        switch self.styleProvider.duration {
        case .seconds(let duration):
            
            self.dismissTimer = Timer.scheduledTimer(withTimeInterval: duration,
                                                     repeats: true,
                                                     block: { [weak self] _ in
                
                guard let self = self else { return }
                guard !self.isCardBeingPanned else { return }
                
                self.dismissTimer?.invalidate()
                self.dismissTimer = nil
                
                self.dismissCard()
                
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
