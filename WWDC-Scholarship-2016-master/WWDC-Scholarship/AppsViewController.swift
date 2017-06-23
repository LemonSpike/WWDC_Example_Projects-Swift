//
//  AppsViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

struct AppsViewControllerDataSource: DragSelectionDataSource {
  var optionViews: [Option] = [
    Option(imageName: "ATeamer", name: "ateamer"),
    Option(imageName: "OneMoreSong", name: "onemoresong"),
    Option(imageName: "WESIS", name: "wesis"),
    Option(imageName: "RWK", name: "rotweissapp"),
    ]
  
  var centerImage: UIImage = UIImage(named: "AppStore")!
}

class AppsViewController: DragSelectionViewController {
  override func viewDidLoad() {
    delegate = AppsViewControllerDataSource()
    super.viewDidLoad()
  }
  
  
  override func bounceIcons() {
    for (view, constraint) in optionViews.map({ ($0.view, $0.widthConstraint) }) {
      constraint.constant = Config.bubblesWidth
      view.layoutIfNeeded()
    }
    self.meViewWidthConstraint.constant = Config.meViewWidth
    self.meView.layoutIfNeeded()
  }
  
  @IBAction func dismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
}
