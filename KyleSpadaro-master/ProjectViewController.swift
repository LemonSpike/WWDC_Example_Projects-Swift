//
//  ProjectViewController.swift
//  Kyle Spadaro Bio
//
//  Created by Kyle Spadaro on 5/1/16.
//  Copyright © 2016 Andrea Spadaro. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var id = "lagometer"
    var dictionary : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = setColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        let url = NSBundle.mainBundle().URLForResource("myInfo", withExtension: "plist")
        dictionary = NSDictionary(contentsOfURL: url!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //tableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("firstCell") as! FirstTableViewCell
            cell.titleLabel.text = setTitle()
            cell.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            cell.subtitleLabel.text = "Status: " + setSubtitle()
            cell.subtitleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
            cell.imageApp.image = setImage()
            self.setImageCustom(cell.imageApp)
            return cell
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("secondCell") as! SecondTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("thirdCell") as! ThirdTableViewCell
        cell.descriptionLabel.text = "Description:"
        cell.descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.textView.text = setText()
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 117
        case 1:
            if id == "lagometer"{
                return 150
            }
            return 340
        default:
            return setCellSize()
        }
    }
    
    //CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCellCollection()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.image.image = setImagesForCollection(indexPath.row)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        performSegueWithIdentifier("pageControllerSegue", sender: nil)
    }
    
    //Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pageControllerSegue"{
            let pvc = segue.destinationViewController as! PageViewController
            let number = numberOfCellCollection()
            for i in 0..<number{
                let imageName = setImagesForCollection(i)
                pvc.images.append(imageName)
            }
        }
    }
    
    //actions
    
    @IBAction func backPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //others
    
    func setImagesForCollection(index: Int) -> UIImage{
        switch id{
        case "lagometer":
            if index == 0{
                return UIImage(named: "lag1")!}
            if index == 1{
                return UIImage(named: "lag2")!}
            return UIImage(named: "lag3")!
        case "kidpaint":
            return UIImage(named: "kp1")!
        default:
            if index == 0{
                return UIImage(named: "kp1")!}
            if index == 1{
                return UIImage(named: "kp2")!}
            return UIImage(named: "kp3")!
        }
    }
    
    func numberOfCellCollection() -> Int{
        switch id{
        case "lagometer":
            return 3
        case "kidpaint":
            return 1
        default:
            return 3
        }
    }
    
    func setCellSize() -> CGFloat{
        switch id{
        case "lagometer":
            return 250
        case "kidpaint":
            return 220
        default:
            return 250
        }
    }
    
    func setImageCustom (image: UIImageView){
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 21
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
    }
    
    func setColor() -> UIColor{
        switch id{
        case "lagometer":
            return UIColor(red: 231/255, green: 54/255, blue: 51/255, alpha: 1.0)
        case "kidpaint":
            return UIColor(red: 255/255, green: 161/255, blue: 68/255, alpha: 1.0)
                default:
            return UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
            
        }
    }
    
    func setTitle() -> String{
        switch id{
        case "lagometer":
            return "Lagometer"
        case "kidpaint":
            return "KidPaint"
        default:
            return "Lagometer"
            
        }
    }
    
    func setSubtitle() -> String{
        switch id{
        case "kidpaint":
            return "Beta Testing"
        case "lagometer":
            return "Rejected from App Store :("
        default:
            return "Beta Testing"
            
        }
    }
    
    func setText() -> String{
        let projects = dictionary.objectForKey("projects") as! NSDictionary
        switch id{
        case "lagometer":
            return projects.valueForKey("lagometer") as! String
        case "kidpaint":
            return projects.valueForKey("kidpaint") as! String
        default:
            return projects.valueForKey("lagometer") as! String
            
        }
    }
    
    func setImage() -> UIImage{
        switch id{
        case "lagometer":
            return UIImage(named:"AppIcon Lagometer")!
        case "kidpaint":
            return UIImage(named:"KidPaint")!
        default:
            return UIImage(named:"Lagometer Icon")!
            
        }
    }
}

