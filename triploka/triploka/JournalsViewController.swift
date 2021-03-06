//
//  JournalsViewController.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 26/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class JournalsViewController: UIViewController , FlatImagePickerViewControllerDelegate , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var sideMenuButton = UIBarButtonItem()
    var addButton : UIBarButtonItem?
    var trips = [Trip]()
    var collectionJournal: UICollectionView!
    var addTripLabel: UILabel?
    var longPressIndex = 0
    var didLongPress = 0
    
    override func viewDidAppear(animated: Bool) {
        didLongPress = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        
        didLongPress = 0
        self.trips = LocalDAO.sharedInstance.getAllTrips()
        self.trips.sort(sorterForTrips)
        
        collectionJournal.reloadData()
        if( self.trips.count == 0)
        {
            self.addTripLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 1.5, 50 ))
            self.addTripLabel!.center = CGPointMake(self.view.center.x, self.view.frame.height / 3 )
            self.addTripLabel!.textAlignment = .Center
            self.addTripLabel!.text = "Add a new trip!"
            self.addTripLabel!.font = UIFont(name: "AmaticSC-Regular", size: 45)
            self.view.addSubview(self.addTripLabel!)
        }
        else
        {
            self.addTripLabel?.removeFromSuperview()
    
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    func sorterForTrips(trip1: Trip, trip2: Trip) -> Bool {
        return trip1.beginDate.timeIntervalSinceNow > trip2.beginDate.timeIntervalSinceNow
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background
        
        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        self.view.addSubview(bg)
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        self.view.addSubview(effectView)
        
     
        
        // Config navigation controller
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        let revealController :SWRevealViewController = self.revealViewController()
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
        
        self.navigationController?.navigationBar.topItem?.title = "Journals"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addTrip"))
        addButton!.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = addButton
        
        
        sideMenuButton.tintColor = UIColor.whiteColor()
        sideMenuButton.image = UIImage(named: "menuButton")
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        
        // Collection View
        
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
        collectionJournal = UICollectionView(frame: CGRectMake( 0, 0, self.view.frame.width, self.view.frame.height - 53), collectionViewLayout: layout)
        collectionJournal.dataSource = self
        collectionJournal.delegate = self
        collectionJournal.userInteractionEnabled = true
        collectionJournal.alwaysBounceVertical = true
        collectionJournal.scrollEnabled = true
        collectionJournal.registerClass(TripCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionJournal.backgroundColor = UIColor.clearColor()
        
        if self.revealViewController() != nil{
            
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = Selector("revealToggle:")
            revealController.viewDisabled = collectionJournal
        }
        
        self.view.addSubview(collectionJournal)
        
    }
    
    
    func addTrip()
    {
        let addvc = AddTripViewController()

        self.navigationController?.pushViewController(addvc, animated: true)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell : TripCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as? TripCollectionViewCell
        
        if cell == nil{
            cell = TripCollectionViewCell()
        }
        
        if trips.count > 0 {
            
            var trip: Trip = trips[indexPath.row]
            cell!.trip = trip
            cell!.tripTitle.text = trip.destination

            let cal = NSCalendar.currentCalendar()

            let unit:NSCalendarUnit = .CalendarUnitDay
            
            let components = cal.components(unit, fromDate: trip.beginDate, toDate: NSDate(), options: nil)
            
            if components.day == 0
            {
                cell?.tripDate.text = "- \(components.day + 1 ) day -"
            }
            else
            {
                cell?.tripDate.text = "- \(components.day + 1 ) days -"
            }
            
            var image: UIImage? = trip.getPresentationImage()
            if image != nil
            {
                cell!.tripCover.image = image
            }
            else
            {
                cell!.tripCover.image = UIImage(named: "city-cars-traffic-lights.jpeg")
            }
            
            cell!.priority = 1
            cell!.tag = indexPath.row
            
            var longPressCover = UILongPressGestureRecognizer(target: self, action: Selector("longPressToEditCover:"))
            cell!.addGestureRecognizer(longPressCover)
            
        }
        
        return cell!
        
    }
    
    
    func longPressToEditCover(gesture: UILongPressGestureRecognizer) {

        if didLongPress == 0
        {
            var flat = FlatImagePickerViewController(shouldSaveImage: false)
            flat.delegate = self
            var cell = gesture.view as! TripCollectionViewCell
            self.longPressIndex = cell.tag
            self.presentViewController(flat, animated: false, completion: nil)
        }
        didLongPress = 1
    }
    
    func FlatimagePickerViewController(imagePicker: FlatImagePickerViewController, didSelectImage image: UIImage) {
     
        trips[self.longPressIndex].presentationImage = image
    }
    
    
    func FlatimagePickerViewControllerDidCancel(imagePicker:FlatImagePickerViewController) {
        
        // longPress era chamado 2 vzs
        didLongPress = 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var timeline = TimelineController()
        
        for tempTrip in self.trips {
            
            println(tempTrip.destination)
            
            let moments = tempTrip.getAllMoments()
            
            for tempMoment in moments {
                
                let category : Int32 = tempMoment.category!.intValue
                
                if category == MomentCategory.Text.rawValue {
                    
                    println(tempMoment.comment!)
                }
                else if category == MomentCategory.Image.rawValue {
                    
                    println(tempMoment.getAllPhotos()[0].description)
                }
            }
        }
        
        timeline.trip = self.trips[indexPath.row]
        self.navigationController?.pushViewController(timeline, animated: true)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.trips.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var cellSize = CGSizeMake( self.view.frame.width, self.view.frame.height / 2 )
        return cellSize
        
    }
    
}
