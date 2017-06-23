//
//  WebViewController.swift
//  Kyle Spadaro Bio
//
//  Created by Kyle Spadaro on 5/1/16.
//  Copyright © 2016 Andrea Spadaro. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var urlString : String!
    var titleWeb : String!
    var connection : NSURLConnection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleWeb
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        let label = UILabel()
        label.text = error.localizedDescription + " :("
        label.textColor = UIColor.grayColor()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.frame = CGRect(x: 8, y: 68, width: self.view.frame.width-8, height: 50)
        self.view.addSubview(label)
    }
    
    @IBAction func donePress(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

