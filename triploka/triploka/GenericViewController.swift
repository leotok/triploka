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
    var statistic1: UILabel!
    var statistic2: UILabel!
    var statistic3: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background
        
        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        self.view.addSubview(bg)
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        self.view.addSubview(effectView)

        
        
        // info do profile
        
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
        
        
        // estatísticas das viagens
        
        self.statistic1 = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 2, 40))
        self.statistic1.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.8)
        self.statistic1.textAlignment = .Center
        self.statistic1.text = "3 different countrys"
        self.statistic1.font = UIFont(name: "AmericanTypewriter", size: 13)
        self.view.addSubview(self.statistic1)

        self.statistic2 = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 2, 40))
        self.statistic2.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.7)
        self.statistic2.textAlignment = .Center
        self.statistic2.text = "5 new friends"
        self.statistic2.font = UIFont(name: "AmericanTypewriter", size: 13)
        self.view.addSubview(self.statistic2)
        
        self.statistic3 = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 2, 40))
        self.statistic3.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.6)
        self.statistic3.textAlignment = .Center
        self.statistic3.text = "11 restaurants"
        self.statistic3.font = UIFont(name: "AmericanTypewriter", size: 13)
        self.view.addSubview(self.statistic3)
        
        
        // configuração navigation controller
        
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
