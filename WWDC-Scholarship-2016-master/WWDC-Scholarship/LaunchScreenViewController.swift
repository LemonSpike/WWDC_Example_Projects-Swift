//
//  LaunchScreenViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

struct LaunchScreenViewControllerDataSource: DragSelectionDataSource {
  var optionViews: [Option] = [
    Option(imageName: "Profile", name: "profile"),
    Option(imageName: "Hockey", name: "hobbies"),
    Option(imageName: "RWTH", name: "education"),
    Option(imageName: "Swift", name: "swift"),
    Option(imageName: "AppStore", name: "apps"),
    ]
  
  var centerImage: UIImage = UIImage(named: "Me")!

}

private var viewControllerDisplayed = false

class LaunchScreenViewController: DragSelectionViewController {
  @IBOutlet var helloYouLabel: UILabel!

  override func viewDidLoad() {
    delegate = LaunchScreenViewControllerDataSource()
    super.viewDidLoad()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if viewControllerDisplayed {
      helloYouLabel.isHidden = true
    }
    viewControllerDisplayed = true
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }

  override func bounceMe() {
    animateMeAndSelectOption(optionViews[0].view)
  }
}
