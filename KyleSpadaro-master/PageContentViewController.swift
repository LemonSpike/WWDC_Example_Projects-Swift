//
//  PageContentViewController.swift
//  Kyle Spadaro Bio
//
//  Created by Kyle Spadaro on 5/1/16.
//  Copyright © 2016 Andrea Spadaro. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    var pageIndex : Int?
    var uiimage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = uiimage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

