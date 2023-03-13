//
//  SettingsPresentationControllerManager.swift
//  catFetcher
//
//  Created by tixomark on 3/20/21.
//

import Foundation
import UIKit

final class SettingsPresentationControllerManager: NSObject {
    
}

extension SettingsPresentationControllerManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SettingsPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return SettingsPresentationControllerAnimator(isPresentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SettingsPresentationControllerAnimator(isPresentation: false)
    }
    
}

extension SettingsPresentationControllerManager: UIAdaptivePresentationControllerDelegate {
    
}
