//
//  DetailViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet var logoView: UIView!
  
  @IBOutlet var attributedTextViews: [UILabel]?
  @IBOutlet var scrollView: UIScrollView?
  var scrollViewSnapshot: UIView?
  
  var dismissalStartPoint: CGPoint?
  
  let backgroundPanGestureRecognizer = UIPanGestureRecognizer()
  let backgroundTapGestureRecognizer = UITapGestureRecognizer()
  
  let dismissInteractiveTransition = UIPercentDrivenInteractiveTransition()
  
  var overlayView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for label in attributedTextViews ?? [] {
      label.replaceDefaultAttributedStringFont()
    }
    
    backgroundPanGestureRecognizer.addTarget(self, action: #selector(backgroundViewPan))
    self.view.addGestureRecognizer(backgroundPanGestureRecognizer)
    backgroundTapGestureRecognizer.addTarget(self, action: #selector(backgroundViewTap))
    self.view.addGestureRecognizer(backgroundTapGestureRecognizer)
    self.view.isUserInteractionEnabled = true
    
    scrollView?.panGestureRecognizer.addTarget(self, action: #selector(scrollViewPan))
    
    scrollView?.delegate = self
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.isDecelerating || scrollView.contentOffset.y > 0
  }
  
  @objc func backgroundViewPan(_ gestureRecognizer: UIPanGestureRecognizer) {
    let window = (UIApplication.shared.delegate as! AppDelegate).window
    
    if gestureRecognizer.state == .began {
      dismiss(animated: true, completion: nil)
      dismissalStartPoint = gestureRecognizer.location(in: window)
    }
    
    updateAnimationProgress(gestureRecognizer)
  }

  fileprivate var tapTimer: Timer?
  fileprivate var tapTime: Date?
  fileprivate var failedDismissCount = 0

  @objc func backgroundViewTap(_ gestureRecognizer: UIPanGestureRecognizer) {
    failedDismissCount += 1

    if failedDismissCount >= 3 {
      showDismissHint()
    } else {
      dismiss(animated: true, completion: nil)
      tapTimer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(updateTap), userInfo: nil, repeats: true)
      tapTime = Date()
    }

  }

  @objc func updateTap() {
    let animationDuration: TimeInterval = 0.3

    let dateDifference = -tapTime!.timeIntervalSinceNow
    if dateDifference > animationDuration {
      dismissInteractiveTransition.cancel()
      tapTimer?.invalidate()
      tapTime = nil
    } else {
      let animationProgress = sin(dateDifference / animationDuration * M_PI) * 0.1
      dismissInteractiveTransition.update(CGFloat(animationProgress))
    }
  }
  
  @objc func scrollViewPan(_ gestureRecognizer: UIPanGestureRecognizer) {
    let window = (UIApplication.shared.delegate as! AppDelegate).window
    
    if dismissalStartPoint == nil && scrollView?.contentOffset.y <= 0 {
      dismissalStartPoint = gestureRecognizer.location(in: window)
      dismiss(animated: true, completion: nil)
    }
    if dismissalStartPoint != nil && scrollView?.contentOffset.y > 0 {
      dismissInteractiveTransition.cancel()
      dismissalStartPoint = nil
    }
    
    updateAnimationProgress(gestureRecognizer)
  }
  
  func updateAnimationProgress(_ gestureRecognizer: UIPanGestureRecognizer) {
    let window = (UIApplication.shared.delegate as! AppDelegate).window
    
    let newCoord = gestureRecognizer.location(in: (UIApplication.shared.delegate as! AppDelegate).window)
    if let dismissalStartPoint = dismissalStartPoint {
      var percentage = (newCoord.y - dismissalStartPoint.y) / (self.view.frame.size.height / 2)
      if percentage > 1 {
        percentage = 1
      }
      if percentage < 0 {
        percentage = 0
      }
      if gestureRecognizer.state == .changed {
        dismissInteractiveTransition.update(percentage)
      } else if gestureRecognizer.state == .cancelled || gestureRecognizer.state == .ended || gestureRecognizer.state == .failed {
        if max(0, min(gestureRecognizer.velocity(in: window).y, 400) / 1000) + percentage > 0.6 {
          // Work around a bug in iOS 9.2 and earlier that causes the application 
          // to deadlock if the transition is completed while percentage is neither 0 nor 1
          if #available(iOS 9.3, *) {
            dismissInteractiveTransition.finish()
          } else {
            dismissInteractiveTransition.update(1)
            dismissInteractiveTransition.finish()
          }
        } else {
          if #available(iOS 9.3, *) {
            dismissInteractiveTransition.cancel()
          } else {
            dismissInteractiveTransition.update(0)
            dismissInteractiveTransition.cancel()
          }
          failedDismissCount += 1
          if failedDismissCount >= 3 {
            showDismissHint()
          }
        }
        self.dismissalStartPoint = nil
      }
    }
  }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if let presenting = presenting as? DragSelectionViewController {
      return DragSelectionToDetailViewTransitionAnimator(logo: UIImage(named: presenting.selectedOption!.imageName)!, meImage: presenting.delegate.centerImage)
    } else {
      return nil
    }
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if let presenting = dismissed.presentingViewController as? DragSelectionViewController {
      return DragSelectionToDetailViewTransitionAnimator(logo: UIImage(named: presenting.selectedOption!.imageName)!, meImage: presenting.delegate.centerImage)
    } else {
      return nil
    }
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return dismissInteractiveTransition
  }
}

import CoreImage
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


private var dismissHintShown = false

extension DetailViewController {
  func showDismissHintIfNeseccary() {
    if !dismissHintShown {
      showDismissHint()
      dismissHintShown = true
    }
  }
  
  func showDismissHint() {
    let blurEffect: UIBlurEffect
    if preferredStatusBarStyle == .lightContent {
      blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    } else {
      blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    }
    
    let overlayView = UIButton(frame: self.view.frame)
    overlayView.addTarget(self, action: #selector(overlayTapped), for: .touchUpInside)
    overlayView.isUserInteractionEnabled = true
    self.overlayView = overlayView
    
    let blurView = UIVisualEffectView(frame: overlayView.bounds)
    blurView.effect = blurEffect
    blurView.isUserInteractionEnabled = false
    overlayView.addSubview(blurView)
    
    let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    vibrancyView.frame = blurView.bounds
    let label = UILabel(frame: CGRect(x: 0, y: 100, width: overlayView.bounds.size.width, height: 30))
    label.text = "Swipe down to dismiss"
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    
    let arrowView = UIImageView(image: UIImage(named: "Arrow")!)
    arrowView.frame = CGRect(x: (vibrancyView.bounds.size.width - 100) / 2, y: 230, width: 100, height: 200)
    vibrancyView.contentView.addSubview(arrowView)
    
    vibrancyView.contentView.addSubview(label)
    blurView.addSubview(vibrancyView)
    
    self.view.addSubview(overlayView)
    
    blurView.effect = nil
    UIView.animate(withDuration: 0.5, animations: {
      blurView.effect = blurEffect
    }) 
    
    
    backgroundPanGestureRecognizer.isEnabled = false
  }
  
  @objc func overlayTapped() {
    UIView.animate(withDuration: 0.5, animations: {
      self.overlayView?.alpha = 0
    }, completion: { (_) in
      self.overlayView?.removeFromSuperview()
      self.overlayView = nil
      self.backgroundPanGestureRecognizer.isEnabled = true
    }) 
  }
}





