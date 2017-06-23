//
//  MeView.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

class MeView: UIButton {
  
  let image: UIImage
  var iv: UIImageView!
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(image: UIImage) {
    self.image = image
    
    super.init(frame: CGRect.zero)
    
    clipsToBounds = true
    
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    iv = imageView
    
    self.addSubview(imageView)
    
    self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
  }
  
  override var bounds: CGRect {
    didSet {
      self.layer.cornerRadius = self.bounds.size.width/2
    }
  }
  
  fileprivate var optionOverlays: [String: UIImageView] = [:]
  
  func setOptionImages(_ overlays: [String: UIImage]) {
    overlays.forEach { (name: String, image: UIImage) in
      let imageView = UIImageView(image: image)
      imageView.alpha = 0
      imageView.contentMode = .scaleAspectFill
      imageView.backgroundColor = UIColor.white
      imageView.translatesAutoresizingMaskIntoConstraints = false
      
      self.addSubview(imageView)
      
      self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
      self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
      self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
      self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
      
      optionOverlays[name] = imageView
    }
  }
  
  func setOverlayAlpha(name: String, alpha: CGFloat) {
    optionOverlays[name]?.alpha = alpha
  }
  
  func resetAllOverlayAlphas(except: String? = nil) {
    for key in optionOverlays.keys {
      if key != except {
        optionOverlays[key]?.alpha = 0
      } else {
        optionOverlays[key]?.alpha = 1
      }
    }
  }
}
