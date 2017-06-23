//
//  AppDetailViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 10/04/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

class AppDetailViewController: DetailViewController {
  
  @IBOutlet var screenshotsScrollView: UIScrollView!
  @IBOutlet var screenshots: [UIView]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    screenshotsScrollView.delegate = self
    
    for screenshotView in screenshots {
      screenshotView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenshotTapped)))
      screenshotView.isUserInteractionEnabled = true
    }
  }
  
  @objc func screenshotTapped(_ sender: UIGestureRecognizer) {
    let screenshotViewController = storyboard?.instantiateViewController(withIdentifier: "ScreenshotViewController") as! ScreenshotViewController
    screenshotViewController.image = (sender.view as! UIImageView).image
    screenshotViewController.modalPresentationStyle = .overCurrentContext
    screenshotViewController.modalTransitionStyle = .crossDissolve
    present(screenshotViewController, animated: true, completion: nil)
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset targetContentOffsetMemory: UnsafeMutablePointer<CGPoint>) {
    let targetContentOffset = targetContentOffsetMemory.pointee
    
    if targetContentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width {
      return
    }
    
    var bestTargetOffset: CGFloat?
    for screenshot in screenshots {
      if bestTargetOffset == nil || abs(screenshot.frame.origin.x - targetContentOffset.x) < abs(bestTargetOffset! - targetContentOffset.x) {
        bestTargetOffset = screenshot.frame.origin.x
      }
    }
    if let bestTargetOffset = bestTargetOffset {
      targetContentOffsetMemory.pointee.x = bestTargetOffset - 20
    }
  }
}
