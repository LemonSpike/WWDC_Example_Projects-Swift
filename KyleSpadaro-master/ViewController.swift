//
//  ViewController.swift
//  Kyle Spadaro Bio
//
//  Created by Kyle Spadaro on 5/1/16.
//  Copyright © 2016 Andrea Spadaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var principalTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var selectedIndexPath: NSIndexPath!
    var myInfo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSBundle.mainBundle().URLForResource("myInfo", withExtension: "plist")
        myInfo = NSDictionary(contentsOfURL: url!)
        let me = myInfo.objectForKey("me") as! NSDictionary
        principalTitle.text = me.valueForKey("introduction") as? String
        principalTitle.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        subtitle.text = me.valueForKey("desc") as? String
        subtitle.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        imageView.image = UIImage(named: "me")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 70
        backgroundImage.image = UIImage(named: "wwdc")
        tableView.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("titleCell") as! TitleTableViewCell
            cell.titleLabel.text = setTitleCell(indexPath)
            cell.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            cell.imageCell.image = UIImage(named: setImage(indexPath))
            cell.imageCell.layer.masksToBounds = true
            cell.imageCell.layer.cornerRadius=22
            if indexPath.row == 0{
                cell.firstView.backgroundColor = UIColor.clearColor()
            }else{
                cell.firstView.backgroundColor = setDetailColor(indexPath)
            }
            if indexPath.row == 10{
                cell.secondView.backgroundColor = UIColor.clearColor()
            }else{
                cell.secondView.backgroundColor = setDetailColor(indexPath)
            }
            return cell
        }
        if indexPath.row == 7{
            let cell = tableView.dequeueReusableCellWithIdentifier("projectsCell") as! ProjectsTableViewCell
            cell.detailView.backgroundColor = setDetailColorText(indexPath)
            cell.label1.text = "Lagometer"
            cell.label1.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
            cell.label2.text = "KidPaint"
            cell.label2.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
            cell.button1.tag = 1
            cell.button2.tag = 2
            self.setButtonCustom(cell.button1)
            self.setButtonCustom(cell.button2)
            return cell
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("aboutCell") as! AboutTableViewCell
            cell.detailView.backgroundColor = setDetailColorText(indexPath)
            cell.textView.text = setText(indexPath)
            cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
            cell.textView.scrollRangeToVisible(NSMakeRange(0, 0))
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell") as! TextTableViewCell
        cell.detailView.backgroundColor = setDetailColorText(indexPath)
        cell.textView.text = setText(indexPath)
        cell.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        if indexPath != selectedIndexPath{
            selectedIndexPath = indexPath
            if indexPath.row == 10{
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! TitleTableViewCell
                cell.secondView.backgroundColor = setDetailColor(indexPath)
            }
        }else{
            if indexPath.row == 10{
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! TitleTableViewCell
                cell.secondView.backgroundColor = UIColor.clearColor()
            }
            selectedIndexPath = nil
        }
        tableView.endUpdates()
        tableView.scrollToRowAtIndexPath(indexPath,atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 10{
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TitleTableViewCell
            cell.secondView.backgroundColor = UIColor.clearColor()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row % 2 == 0{
            return 77
        }else if selectedIndexPath != nil && indexPath.row == selectedIndexPath.row+1{
            return sizeCell(indexPath)
        }
        return 0
    }
    
    //Actions
    
    @IBAction func projectPressed(sender: UIButton) {
        performSegueWithIdentifier("projectSegue", sender: sender)
    }
    
    @IBAction func socialMediaPressed(sender: UIButton) {
        performSegueWithIdentifier("webViewSegue", sender: sender)
    }
    
    //Sets
    
    func setButtonCustom (button: UIButton){
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 21
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
    }
    
    func sizeCell(indexPath: NSIndexPath) -> CGFloat{
        switch indexPath.row{
        case 1:
            return 335
        case 3:
            return 350
        case 5:
            return 350
        case 7:
            return 230
        case 9:
            return 190
        default:
            return 200
        }
    }
    
    
    func setText(indexPath: NSIndexPath) -> String{
        let me = myInfo.objectForKey("me") as! NSDictionary
        let background = myInfo.objectForKey("background") as! NSDictionary
        let experiences = myInfo.objectForKey("experiences") as! NSDictionary
        let interests = myInfo.objectForKey("interests") as! NSDictionary
        let dreams = myInfo.objectForKey("dreams") as! NSDictionary
        
        switch indexPath.row{
        case 1:
            return me.valueForKey("about") as! String
        case 3:
            return background.valueForKey("about") as! String
        case 5:
            return experiences.valueForKey("about") as! String
        case 9:
            return interests.valueForKey("about") as! String
        default:
            return dreams.valueForKey("about") as! String
        }
    }
    
    func setDetailColor(indexPath: NSIndexPath) -> UIColor{
        switch indexPath.row{
        case 0:
            return UIColor(red:30/255, green:142/255, blue:205/255, alpha: 1.0)
        case 2:
            return UIColor(red:211/255, green:34/255, blue:49/255, alpha: 1.0)
        case 4:
            return UIColor(red:149/255, green:188/255, blue:74/255, alpha: 1.0)
        case 6:
            return UIColor(red:122/255, green:48/255, blue:223/255, alpha: 1.0)
        case 8:
            return UIColor(red:240/255, green:106/255, blue:39/255, alpha: 1.0)
        default:
            return UIColor(red:73/255, green:215/255, blue:216/255, alpha: 1.0)
        }
    }
    
    func setDetailColorText(indexPath: NSIndexPath) -> UIColor{
        switch indexPath.row{
        case 1:
            return UIColor(red:30/255, green:142/255, blue:205/255, alpha: 1.0)
        case 3:
            return UIColor(red:211/255, green:34/255, blue:49/255, alpha: 1.0)
        case 5:
            return UIColor(red:149/255, green:188/255, blue:74/255, alpha: 1.0)
        case 7:
            return UIColor(red:122/255, green:48/255, blue:223/255, alpha: 1.0)
        case 9:
            return UIColor(red:240/255, green:106/255, blue:39/255, alpha: 1.0)
        default:
            return UIColor(red:73/255, green:215/255, blue:216/255, alpha: 1.0)
        }
    }
    
    func setTitleCell(indexPath: NSIndexPath) -> String{
        switch indexPath.row{
        case 0:
            return "About Me"
        case 2:
            return "Background"
        case 4:
            return "Experiences"
        case 6:
            return "Projects"
        case 8:
            return "Interests"
        default:
            return "Dreams"
        }
    }
    
    func setImage(indexPath: NSIndexPath) -> String{
        switch indexPath.row{
        case 0:
            return "about me"
        case 2:
            return "background"
        case 4:
            return "experiences"
        case 6:
            return "projects"
        case 8:
            return "interests"
        default:
            return "dreams"
        }
    }
    
    //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "projectSegue"{
            let dvc = segue.destinationViewController as! UINavigationController
            let vc = dvc.viewControllers[0] as! ProjectViewController
            let tagindex = (sender as! UIButton).tag
            if tagindex == 1{
                vc.id = "lagometer"
            }else if tagindex == 2{
                vc.id = "kidpaint"
            }else if tagindex == 3{
                vc.id = "steve"
            
            }
        }
        
            if segue.identifier == "webViewSegue"{
            let senderButton = sender as! UIButton
            let ident = senderButton.restorationIdentifier
            let dvc = segue.destinationViewController as! UINavigationController
            let wvc = dvc.viewControllers[0] as! WebViewController
            let me = myInfo.objectForKey("me") as! NSDictionary
            
            if ident == "facebook"{
                wvc.urlString = me.valueForKey("facebook") as! String
                wvc.titleWeb = "Facebook"
            }else if ident == "git" {
                wvc.urlString = me.valueForKey("git") as! String
                wvc.titleWeb = "Git"
            } else {
                wvc.urlString = me.valueForKey("twitter") as! String
                wvc.titleWeb = "Twitter"
            }
        }
    }
}
