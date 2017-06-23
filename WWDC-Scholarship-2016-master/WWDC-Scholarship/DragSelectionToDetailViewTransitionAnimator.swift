//
//  DragSelectionToDetailViewTransitionAnimator.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

class DragSelectionToDetailViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let logo: UIImage
  let meImage: UIImage
  
  init(logo: UIImage, meImage: UIImage) {
    self.logo = logo
    self.meImage = meImage
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    
    let isUnwinding = (toViewController.presentedViewController === fromViewController)
    let isPresenting = !isUnwinding
    
    let presentingViewController = (isPresenting ? fromViewController : toViewController) as! DragSelectionViewController
    let presentedViewController = isPresenting ? toViewController : fromViewController
    let detailViewController = presentedViewController as! DetailViewController
    
    if isPresenting {
      let destinationCenter = presentingViewController.view.center

      detailViewController.view.setNeedsLayout()
      detailViewController.view.layoutIfNeeded()
      
      let imageViewDestination = detailViewController.logoView.superview!.convert(detailViewController.logoView.frame, to: containerView)
      
      containerView.addSubview(presentedViewController.view)
      containerView.bringSubview(toFront: presentedViewController.view)
      presentedViewController.view.transform = CGAffineTransform(scaleX: 0, y: 0)
      presentedViewController.view.center = presentingViewController.meView.center

      let imageView = UIImageView(image: logo)
      imageView.frame = presentingViewController.meView.frame
      imageView.layer.cornerRadius = imageView.frame.size.width/2
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      containerView.addSubview(imageView)
      
      presentedViewController.view.alpha = 0.5
      detailViewController.logoView.alpha = 0
      
      let animation = CABasicAnimation(keyPath:"cornerRadius")
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
      animation.fromValue = imageView.layer.cornerRadius
      animation.toValue = detailViewController.logoView.layer.cornerRadius
      animation.duration = transitionDuration(using: transitionContext)
      imageView.layer.add(animation, forKey: "cornerRadius")
      imageView.layer.cornerRadius = detailViewController.logoView.layer.cornerRadius
      
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
        presentedViewController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        presentedViewController.view.center = destinationCenter
        presentedViewController.view.alpha = 1
        
        imageView.frame = imageViewDestination
        
        }, completion: { (_) in
          imageView.removeFromSuperview()
          detailViewController.logoView.alpha = 1
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
      
    } else {
      containerView.addSubview(presentingViewController.view)
      containerView.sendSubview(toBack: presentingViewController.view)
      
      presentedViewController.view.isHidden = true
      let presentedViewControllerSnapshot = presentedViewController.view.snapshotView(afterScreenUpdates: false)
      containerView.addSubview(presentedViewControllerSnapshot!)
      
      let animatedLogoView = UIImageView(image: logo)
      animatedLogoView.layer.cornerRadius = detailViewController.logoView.layer.cornerRadius
      let animatedMeImageView = UIImageView(image: meImage)
      animatedMeImageView.alpha = 0
      
      animatedLogoView.frame = detailViewController.logoView.superview!.convert(detailViewController.logoView.frame, to: containerView)
      animatedLogoView.contentMode = .scaleAspectFill
      animatedLogoView.clipsToBounds = true
      
      animatedMeImageView.frame = animatedLogoView.frame
      animatedMeImageView.layer.cornerRadius = animatedLogoView.layer.cornerRadius
      animatedMeImageView.clipsToBounds = true
      animatedMeImageView.contentMode = .scaleAspectFill
      
      containerView.addSubview(animatedLogoView)
      containerView.insertSubview(animatedMeImageView, aboveSubview: animatedLogoView)
      
      detailViewController.logoView.alpha = 0
      
      presentingViewController.meViewXConstraint.constant = 0
      presentingViewController.meViewYConstraint.constant = 0
      presentingViewController.meView.layoutIfNeeded()
      presentingViewController.meView.isHidden = true
      
      let animation = CABasicAnimation(keyPath:"cornerRadius")
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
      animation.fromValue = animatedLogoView.layer.cornerRadius
      animation.toValue = presentingViewController.meView.layer.cornerRadius
      animation.duration = transitionDuration(using: transitionContext)/2
      
      animatedLogoView.layer.add(animation, forKey: "cornerRadius")
      animatedLogoView.layer.cornerRadius = presentingViewController.meView.layer.cornerRadius
      
      animatedMeImageView.layer.add(animation, forKey: "cornerRadius")
      animatedMeImageView.layer.cornerRadius = presentingViewController.meView.layer.cornerRadius
      
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
        presentedViewControllerSnapshot?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        animatedLogoView.frame = presentingViewController.meView.frame
        animatedMeImageView.frame = presentingViewController.meView.frame
        animatedMeImageView.alpha = 1
        presentedViewControllerSnapshot?.alpha = 0.5
        
        }, completion: { (_) in
          if transitionContext.transitionWasCancelled {
            presentingViewController.view.removeFromSuperview()
          }
          
          presentedViewControllerSnapshot?.removeFromSuperview()
          animatedLogoView.removeFromSuperview()
          animatedMeImageView.removeFromSuperview()
          presentingViewController.meView.resetAllOverlayAlphas()
          detailViewController.logoView.alpha = 1
          presentingViewController.meView.isHidden = false
          presentedViewController.view.isHidden = false
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
      
    }
  }
}
