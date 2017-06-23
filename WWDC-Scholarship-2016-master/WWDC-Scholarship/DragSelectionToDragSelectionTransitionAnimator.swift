//
//  DragSelectionToDragSelectionTransitionAnimator.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

class DragSelectionToDragSelectionTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let meImage = UIImage(named: "Me.jpg")
  let selectedOption: Option
  
  init(selectedOption: Option) {
    self.selectedOption = selectedOption
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    if transitionContext!.viewController(forKey: UITransitionContextViewControllerKey.to)!.presentedViewController === transitionContext!.viewController(forKey: UITransitionContextViewControllerKey.from)! {
      return 1
    } else {
      return 0.5
    }
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    
    let isUnwinding = (toViewController.presentedViewController === fromViewController)
    let isPresenting = !isUnwinding
    
    let presentingViewController = (isPresenting ? fromViewController : toViewController) as! DragSelectionViewController
    let presentedViewController = (isPresenting ? toViewController : fromViewController) as! DragSelectionViewController
    
    if isPresenting {
      presentedViewController.bounceIcons()
      presentedViewController.view.layoutIfNeeded()
      
      UIGraphicsBeginImageContextWithOptions(presentedViewController.animatedChrome!.bounds.size, false, UIScreen.main.scale);
      presentedViewController.animatedChrome?.layer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      let animatedChromeSnapshot: Optional = UIImageView(image: image)
      if let animatedChromeSnapshot = animatedChromeSnapshot {
        containerView.addSubview(animatedChromeSnapshot)
        animatedChromeSnapshot.alpha = 0
      }
      
      let newIcons = presentedViewController.optionViews.map { (option) -> (view: UIView, destinationFrame: CGRect) in
        let imageView = UIImageView(image: UIImage(named: option.imageName))
        imageView.frame.size = option.view.frame.size
        imageView.center = presentingViewController.meView.center
        imageView.layer.cornerRadius = option.view.layer.cornerRadius
        return (imageView, option.view.frame)
      }
      
      let newCenterImageView = UIImageView(image: UIImage(named: selectedOption.imageName))
      newCenterImageView.frame = selectedOption.view.frame
      newCenterImageView.layer.cornerRadius = presentedViewController.meView.frame.size.width/2
      containerView.addSubview(newCenterImageView)
      
      for (iconView, _) in newIcons {
        containerView.addSubview(iconView)
      }
      
      presentingViewController.meView.isHidden = true
      selectedOption.view.isHidden = true
      
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
        presentingViewController.optionViewConstraints.forEach({
          $0.constant *= 3
        })
        presentingViewController.view.layoutIfNeeded()
        
        for (iconView, destinationFrame) in newIcons {
          iconView.frame = destinationFrame
        }
        
        newCenterImageView.frame.size = presentedViewController.meView.frame.size
        newCenterImageView.center = presentedViewController.view.center
        
        animatedChromeSnapshot?.alpha = 1
        
        presentingViewController.animatedChrome?.alpha = 0
        
        }, completion: { (_) in
          presentingViewController.optionViewConstraints.forEach({
            $0.constant /= 3
          })
          newIcons.forEach({
            $0.0.removeFromSuperview()
          })
          newCenterImageView.removeFromSuperview()
          
          containerView.addSubview(presentedViewController.view)
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
          presentingViewController.meViewXConstraint.constant = 0
          presentingViewController.meViewYConstraint.constant = 0
          presentingViewController.meView.isHidden = false
          self.selectedOption.view.isHidden = false
          presentingViewController.meView.resetAllOverlayAlphas()
          if let animatedChromeSnapshot = animatedChromeSnapshot {
            animatedChromeSnapshot.removeFromSuperview()
          }
          
          presentingViewController.animatedChrome?.alpha = 1
      })
    } else {
      containerView.addSubview(presentingViewController.view)
      containerView.sendSubview(toBack: presentingViewController.view)
      
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
        presentedViewController.view.alpha = 0
        presentedViewController.optionViewConstraints.forEach({
          $0.constant = 0
        })
        presentedViewController.optionViews.forEach({
          $0.widthConstraint.constant = 0
          $0.view.alpha = 0.5
        })
        let oldCornerRadius = presentedViewController.meView.layer.cornerRadius
        presentedViewController.meViewWidthConstraint.constant = 1
        presentedViewController.meView.layoutIfNeeded()
        presentedViewController.view.layoutIfNeeded()
        presentedViewController.meView.layer.cornerRadius = oldCornerRadius
        }, completion: { (_) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
  }
}
