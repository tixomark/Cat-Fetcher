//
//  SettingsPresentationController.swift
//  catFetcher
//
//  Created by tixomark on 3/17/21.
//

import UIKit

final class SettingsPresentationController: UIPresentationController {
    
    private var blurView: UIVisualEffectView!
    private var dimView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setUpBlurView()
        setUpDimView()
        
    }
    
    override func presentationTransitionWillBegin() {
        
        guard let blurView = blurView, let dimView = dimView else { return }
        presentedView?.insertSubview(blurView, at: 0)
        blurView.frame = presentedView!.bounds
        containerView?.addSubview(dimView)
        dimView.frame = containerView!.bounds
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimView.alpha = 1.0
            return
        }
        
        coordinator.animate { _ in
            self.dimView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimView.alpha = 0.0
            return
        }
        coordinator.animate { _ in
            self.dimView.alpha = 0.0
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        
        presentedView?.layer.cornerRadius = 40
        presentedView?.clipsToBounds = true
        presentedView?.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = containerView!.layoutMargins
        presentedView?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: margins.left).isActive = true
        presentedView?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -(margins.right)).isActive = true
        presentedView?.bottomAnchor.constraint(lessThanOrEqualTo: containerView!.bottomAnchor, constant: -(margins.bottom)).isActive = true
    }
}

private extension SettingsPresentationController {
    func setUpBlurView() {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 1.0
        
        let recogniser = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        recogniser.direction = .down
        blurView.addGestureRecognizer(recogniser)
    }
    
    func setUpDimView() {
        dimView = UIView()
        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        dimView.alpha = 0.0
        
        let swipeRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        swipeRecogniser.direction = .down
        dimView.addGestureRecognizer(swipeRecogniser)
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        dimView.addGestureRecognizer(tapRecogniser)
    }
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        switch recognizer {
        case is UITapGestureRecognizer:
            presentingViewController.dismiss(animated: true)
        case is UISwipeGestureRecognizer:
            presentingViewController.dismiss(animated: true)
        default:
            return
        }
    }
}

