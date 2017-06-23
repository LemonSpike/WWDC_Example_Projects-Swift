//
//  DragSelectionViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 29/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

extension CGPoint {
  func distanceTo(_ point: CGPoint) -> CGFloat {
    return hypot(x - point.x, y - point.y)
  }
  
  func adding(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + x, y: self.y + y)
  }
  
  func minus(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: x - point.x, y: y - point.y)
  }
  
  func normalize() -> CGPoint {
    let normalizingFactor = 1 / hypot(x, y)
    return self.strech(normalizingFactor)
  }
  
  func strech(_ factor: CGFloat) -> CGPoint {
    return CGPoint(x: x * factor, y: y * factor)
  }
}

extension NSLayoutConstraint {
  public convenience init(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat, priority: UILayoutPriority) {
    self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
    self.priority = priority
  }
}

struct Option {
  let view: UIButton
  let name: String
  let imageName: String
  var widthConstraint: NSLayoutConstraint!
  
  init(imageName: String, name: String) {
    self.imageName = imageName
    let image = UIImage(named: imageName);
    self.view = UIButton(type: .custom)
    self.view.setImage(image, for: UIControlState())
    self.view.backgroundColor = UIColor.white
    self.view.imageView?.contentMode = .scaleAspectFill
    self.view.clipsToBounds = true
    self.name = name
    self.widthConstraint = nil
  }
}

enum Config {
  static let viewDidAppearBounceDuration: Double = 1.5
  static let meViewWidth: CGFloat = 100
  static let bubblesWidth: CGFloat = 70
  static let bubbleSelectionRadius: CGFloat = 80
  static let flickFactor: CGFloat = 0.2
  static let linearLayoutTopMargin: CGFloat = 30
  static let linearLayoutBottomMargin: CGFloat = 20
}

protocol DragSelectionDataSource {
  var optionViews: [Option] { get }
  var centerImage: UIImage { get }
}

class DragSelectionViewController: UIViewController {
  
  @IBOutlet var animatedChrome: UIView?
  
  var meView: MeView!
  var meViewXConstraint: NSLayoutConstraint!
  var meViewYConstraint: NSLayoutConstraint!
  var meViewWidthConstraint: NSLayoutConstraint!
  var panGestureRecogniser: UIPanGestureRecognizer!
  
  var meViewPanStartPoint: CGPoint!
  var meViewLastVelocity: CGPoint!
  
  var delegate: DragSelectionDataSource!
  
  var optionViews: [Option]!
  
  var optionViewConstraints: [NSLayoutConstraint] = []
  
  var selectedOption: Option?
  
  let circularLayout = true
  
  var selectBubbleAnimationInProgress = false
  
  override func viewDidLoad() {
    optionViews = delegate.optionViews
    meView = MeView(image: delegate.centerImage)
    
    createBubbles()
    var optionImages = [String:UIImage]()
    for option in optionViews {
      optionImages[option.name] = UIImage(named: option.imageName)
    }
    meView.setOptionImages(optionImages)
    
    super.viewDidLoad()
    
    setUpMeView()
    
    meViewWidthConstraint.constant = 0
  }
  
  fileprivate func setUpMeView() {
    panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(dragView))
    meView.addGestureRecognizer(panGestureRecogniser)
    
    view.addSubview(meView)
    
    meView.translatesAutoresizingMaskIntoConstraints = false
    
    let aspectRatioConstraint = NSLayoutConstraint(item: meView, attribute: .height, relatedBy: .equal, toItem: meView, attribute: .width, multiplier: 1, constant: 0)
    meViewWidthConstraint = NSLayoutConstraint(item: meView.iv, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Config.meViewWidth)
    if circularLayout {
      meViewXConstraint = NSLayoutConstraint(item: meView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
    } else {
      meViewXConstraint = NSLayoutConstraint(item: meView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
    }
    meViewYConstraint = NSLayoutConstraint(item: meView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
    
    meView.addConstraints([aspectRatioConstraint, meViewWidthConstraint])
    view.addConstraints([meViewXConstraint, meViewYConstraint])
    
    meView.addTarget(self, action: #selector(bounceMe), for: .touchUpInside)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    bounceIcons()
  }
  
  func bounceIcons() {
    meView.layoutIfNeeded()
    var tuple = (index: Int, element: (view: UIView, constraint: NSLayoutConstraint))()
    for tuple in optionViews.map({ ($0.view, $0.widthConstraint) }).enumerated() {
      UIView.animate(withDuration: Config.viewDidAppearBounceDuration,
                                 delay: Double(tuple.index)/10,
                                 usingSpringWithDamping: 0.3,
                                 initialSpringVelocity: 0,
                                 options: [],
                                 animations: {
                                  constraint.constant = Config.bubblesWidth
                                  view.layoutIfNeeded()
        }, completion: nil)
    }
    UIView.animate(withDuration: Config.viewDidAppearBounceDuration,
                               delay: Double(optionViews.count)/10,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0,
                               options: [],
                               animations: {
                                self.meViewWidthConstraint.constant = Config.meViewWidth
                                self.meView.layoutIfNeeded()
      }, completion: nil)
  }
  
  func createBubbles() {
    for (index, option) in optionViews.enumerated() {
      option.view.addTarget(self, action: #selector(animateMeAndSelectOption), for: .touchUpInside)
      
      self.view.insertSubview(option.view, belowSubview: meView)
      option.view.translatesAutoresizingMaskIntoConstraints = false
      option.view.addConstraint(NSLayoutConstraint(item: option.view, attribute: .width, relatedBy: .equal, toItem: option.view, attribute: .height, multiplier: 1, constant: 0))
      let widthConstraint = NSLayoutConstraint(item: option.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
      option.view.addConstraint(widthConstraint)
      optionViews[index].widthConstraint = widthConstraint
      option.view.layer.cornerRadius = 20
      
      if circularLayout {
        let ellipsisWidth = self.view.frame.size.width / 3
        let ellipsisHeight = ellipsisWidth * 1.3
        let dx = sin(2 * CGFloat(M_PI) * CGFloat(index) / CGFloat(optionViews.count)) * ellipsisWidth
        let dy = -cos(2 * CGFloat(M_PI) * CGFloat(index) / CGFloat(optionViews.count)) * ellipsisHeight
        
        let xConstraint = NSLayoutConstraint(item: option.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: dx)
        let yConstraint = NSLayoutConstraint(item: option.view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: dy)
        
        optionViewConstraints.append(xConstraint)
        optionViewConstraints.append(yConstraint)
      } else {
        let spacing = (self.view.frame.size.height - Config.linearLayoutTopMargin - Config.linearLayoutBottomMargin - Config.bubblesWidth) / CGFloat(optionViews.count - 1)
        
        let xConstraint = NSLayoutConstraint(item: option.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -20)
        let yConstraint = NSLayoutConstraint(item: option.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: CGFloat(index) * spacing + Config.linearLayoutTopMargin)
        
        optionViewConstraints.append(xConstraint)
        optionViewConstraints.append(yConstraint)
      }
    }
    self.view.addConstraints(optionViewConstraints)
  }
  
  @IBAction func dragView(_ gestureRecognizer: UIPanGestureRecognizer) {
    if gestureRecognizer.state == .began {
      meViewPanStartPoint = gestureRecognizer.location(in: gestureRecognizer.view)
    }
    
    let newCoord = gestureRecognizer.location(in: gestureRecognizer.view)
    let dx = newCoord.x - meViewPanStartPoint.x
    let dy = newCoord.y - meViewPanStartPoint.y
    
    self.meViewXConstraint.constant += dx
    self.meViewYConstraint.constant += dy
    
    for option in optionViews {
      let distance = self.meView.center.distanceTo(option.view.center)
      let alpha = max((Config.bubbleSelectionRadius - distance)/Config.bubbleSelectionRadius, 0)
      meView.setOverlayAlpha(name: option.name, alpha: alpha)
    }
    
    if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled || gestureRecognizer.state == .failed {
      meView.layoutIfNeeded()
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1/Config.flickFactor, options: [], animations: {
        self.meViewXConstraint.constant += self.meViewLastVelocity.x * Config.flickFactor
        self.meViewYConstraint.constant += self.meViewLastVelocity.y * Config.flickFactor
        self.meView.layoutIfNeeded()
        }, completion: nil)
      
      let selectedOption = optionViews.lazy.filter({ $0.view.center.distanceTo(self.meView.center) < 100 }).first
      self.selectedOption = selectedOption
      
      if let selectedOption = selectedOption {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
          self.meViewXConstraint.constant = selectedOption.view.center.x - self.view.center.x
          self.meViewYConstraint.constant = selectedOption.view.center.y - self.view.center.y
          self.meView.layoutIfNeeded()
          self.meView.resetAllOverlayAlphas(except: selectedOption.name)
          }, completion: { (_) in
            self.performTransition(selectedOption.name)
        })
      } else {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
          self.meViewXConstraint.constant = 0
          self.meViewYConstraint.constant = 0
          self.meView.layoutIfNeeded()
          self.meView.resetAllOverlayAlphas()
          }, completion: nil)
      }
    }
    meViewLastVelocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
  }
  
  func performTransition(_ transitionName: String) {
    performSegue(withIdentifier: transitionName, sender: self)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let transitioningDelegate = segue.destination as? UIViewControllerTransitioningDelegate {
      segue.destination.transitioningDelegate = transitioningDelegate
    }
  }
  
  @IBAction func animateMeAndSelectOption(_ sender: AnyObject) {
    guard !selectBubbleAnimationInProgress else {
      return
    }
    guard let selectedOption = optionViews.lazy.filter({ $0.view === sender }).first else {
      return
    }
    selectBubbleAnimationInProgress = true
    
    self.selectedOption = selectedOption
    
    let offset = sender.center.minus(self.meView.center)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { 
      self.meViewXConstraint.constant = offset.x
      self.meViewYConstraint.constant = offset.y
      self.meView.layoutIfNeeded()
      
      self.meView.setOverlayAlpha(name: selectedOption.name, alpha: 1)
      }, completion: { (_) in
        self.performTransition(selectedOption.name)
        self.selectBubbleAnimationInProgress = false
    })
  }
  
  @IBAction func bounceMe() {
    self.meViewYConstraint.constant = 1
    self.meView.layoutIfNeeded()
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 3000, options: [], animations: {
      self.meViewYConstraint.constant = 0
      self.meView.layoutIfNeeded()
      }, completion: nil)
  }
  
}

extension DragSelectionViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if let presenting = presenting as? DragSelectionViewController {
      return DragSelectionToDragSelectionTransitionAnimator(selectedOption: presenting.selectedOption!)
    } else {
      return nil
    }
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if let presenting = dismissed.presentingViewController as? DragSelectionViewController {
      return DragSelectionToDragSelectionTransitionAnimator(selectedOption: presenting.selectedOption!)
    } else {
      return nil
    }
  }
}
