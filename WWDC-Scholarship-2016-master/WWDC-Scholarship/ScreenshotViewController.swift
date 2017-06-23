//
//  ScreenshotViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 10/04/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

class ScreenshotViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  
  var image: UIImage? {
    didSet {
      if let imageView = imageView {
        imageView.image = image
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let image = image {
      imageView.image = image
    }
  }
  
  @IBAction func dismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
}
