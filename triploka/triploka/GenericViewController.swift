//
//  GenericViewController.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 25/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

import CoreData
import CoreLocation

class GenericViewController: UIViewController,SWRevealViewControllerDelegate {
    
    var sideMenuButton = UIBarButtonItem()
    var color :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "blurMenu")
        bg.alpha = 0.1
        self.view.addSubview(bg)
        
        var profilePic = UIImageView(image: UIImage(named: "leoProfile.jpg"))
        profilePic.frame.size = CGSizeMake(150, 150)
        profilePic.center = CGPointMake(self.view.center.x, self.view.bounds.height / 5)
        profilePic.layer.cornerRadius = 75
        profilePic.clipsToBounds = true
        self.view.addSubview(profilePic)
        
        var username = UILabel()
        username.frame.size = CGSizeMake(200, 40)
        username.center =  CGPointMake(self.view.center.x, self.view.frame.height / 2.5)
        username.textAlignment = .Center
        username.text = "Leo Wajnsztok"
        username.font = UIFont(name: "AmaticSC-Regular", size: 30)
        self.view.addSubview(username)
        
        var tripify = UIImageView(image: UIImage(named: "tripifyWhite"))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.topItem?.titleView = tripify
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let revealController :SWRevealViewController = self.revealViewController()
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
        
        sideMenuButton.tintColor = UIColor.whiteColor()
        sideMenuButton.image = UIImage(named: "Menu-25")
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        
        if self.revealViewController() != nil{
            
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = Selector("revealToggle:")
            
        }
        
        //self.test()
        
    }
    
    
    //    func test(){
    //
    ////        var testMoment = Moment()
    /////Users/LeoWajnsztok/Desktop/Captura de Tela 2015-05-30 às 00.05.15.png
    ////        testMoment.changeGeoTag(CLLocation(latitude: 2423423, longitude: 234234234))
    ////        testMoment.addNewPhoto(UIImage(named: "teste")!)
    ////        testMoment.addNewPhoto(UIImage(named: "maria")!)
    ////        testMoment.addNewPhoto(UIImage(named: "arc")!)
    //
    //
    //        var appDelegate : AppDelegate
    //        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //        var context = appDelegate.managedObjectContext
    //
    //
    //        var request : NSFetchRequest
    //        request = NSFetchRequest(entityName: "Moment")
    //
    //        var erro : NSError?
    //        var result : [Moment]
    //
    //        result = context!.executeFetchRequest(request, error: &erro)! as! [Moment]
    //        println(result.count)
    //
    //        var allImages : [UIImage]?
    //
    //        for moment in result{
    //            
    //            allImages = moment.getAllPhotos()
    //            println(allImages!.count)
    //        }
    //    }
}
