//
//  LocalDAO.swift
//  triploka
//
//  Created by Victor Yves Crispim on 06/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import CoreData

/**
 *
 *   This class is responsible for the configuration and management
 *   of the CoreData Stack.
 *
*/
class LocalDAO {
    
    static let sharedInstance = LocalDAO()
    
    

    /*********************************************
    *
    *  MARK: - CoreData Stack
    *
    ***/
    
    lazy var applicationDocumentsDirectory: NSURL = {

        //  The directory the application uses to store the Core Data store file.
        //  This code uses a directory named "com.leowajnsztok.triploka" in the application's documents
        //  Application Support directory.
        
        let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory,
                                                                    inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {

        //  The managed object model for the application. This property is not optional.
        //  It is a fatal error for the application not to be able to find and load its model.
        
        let modelURL = NSBundle.mainBundle().URLForResource("triploka", withExtension: "momd")!
    
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        //  The persistent store coordinator for the application. This implementation creates and return a coordinator,
        //  having added the store for the application to it. This property is optional since there are legitimate error 
        //  conditions that could cause the creation of the store to fail. Create the coordinator and store
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("triploka.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
        
            coordinator = nil
            
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            //  Replace this with code to handle the error appropriately.
            //  abort() causes the application to generate a crash log and terminate.
            //  You should not use this function in a shipping application, although it may be useful during development.
            
            println("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        //  Returns the managed object context for the application (which is already bound to the persistent store coordinator
        //  for the application.) This property is optional since there are legitimate error conditions that could cause 
        //  the creation of the context to fail.
        
        let coordinator = self.persistentStoreCoordinator

        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()

    
    
    /*********************************************
    *
    *  MARK: Initializer
    *
    ***/
    
    private init(){
    }
    
    
    
    /*********************************************
    *
    *  MARK: CoreData Saving support
    *
    ***/
  
    /**
     *
     *   Saves the ManagedObjectContext state to the Persistent Store.
     *
    */
    func saveContext () {

        if let moc = self.managedObjectContext {
        
            var error: NSError? = nil
      
            if moc.hasChanges && !moc.save(&error) {
                
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. 
                // You should not use this function in a shipping application, 
                // although it may be useful during development.
                
                println("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

    
    
    /*********************************************
    *
    *  MARK: CoreData Loading support
    *
    ***/
    
    /**
     *
     *  Loads into the Managed Object Context all Trips
     *  and Moments from the Persistent Store
     *
    */
    func loadObjectGraph(){

        let tripRequest = NSFetchRequest(entityName: "Trip")
        let momentRequest = NSFetchRequest(entityName: "Moment")
        
        var error : NSError?

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            self.managedObjectContext?.executeFetchRequest(tripRequest, error: &error)
            
            if error != nil{
                println("Erro no fetch inicial: viagens não carregadas")
            }
            
            self.managedObjectContext?.executeFetchRequest(momentRequest, error: &error)

            if error != nil{
                println("Erro no fetch inicial: momentos não carregados")
            }
            
            println("Fetch inicial concluido com sucesso")
        }
    }
    
    

    /*********************************************
    *
    *  MARK: Getter Methods
    *
    ***/
    
    /**
     *
     *  Gets the username previously set by the user,
     *  or a default username otherwise
     *
    */
    func getUserName() -> String{
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let username: AnyObject = userDefaults.objectForKey("username"){
            return username as! String
        }
        else{
            return UIDevice.currentDevice().name
        }
    }
    
    /**
     *
     *  Gets the profile image previously set by the user,
     *  or a default one otherwise
     *
    */
    func getUserProfileImage() -> UIImage{
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userProfileImage: NSData = userDefaults.dataForKey("userProfileImage"){
            return UIImage(data: userProfileImage)!
        }
        else{
            return UIImage(named: "defaultUserProfileImage")!
        }
    }
    
    /**
     *
     *  Returns the user defined preference for saving photos
     *  to the Photo Gallery. The default is false
     *
     *  :returns:   - true if the user wants to save photos to the gallery
     *              - false if not
     *
    */
    func shouldSaveToPhotoGallery() -> Bool{
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let galleryPhotoSavingOption: AnyObject = userDefaults.objectForKey("galleryPhotoSavingOption"){
            return galleryPhotoSavingOption as! Bool
        }
        else{
            return false
        }
    }

    /**
     *
     *  Gets all the Trips stored on the CoreData Sersistent Store
     *
     *  :returns: An array of Trip objects
     *
    */
    func getAllTrips() -> [Trip]{
        
        let tripRequest = NSFetchRequest(entityName: "Trip")
        
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(tripRequest, error: &error)
        
        if error != nil{
            println("Erro: viagens não carregadas. \(error)")
        }
        
        return tripsArray as! [Trip]
    }
    
    /**
     *
     *  Gets the total number of different countries visited so far
     *
    */
    func getNumberOfVisitedCountries() -> Int{
        
        let request = NSFetchRequest(entityName: "Trip")
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error) as! [Trip]
        
        
        var destinations = NSMutableSet()
        
        for trip in tripsArray{
            
            if !trip.destination.isEmpty{
                
                destinations.addObject(trip.destination)
            }
        }
        
        return destinations.count
    }

    /**
     *
     *  Gets the total number of new friends met so far
     *
    */
    func getNumberOfNewFriends() -> Int{
        
        let request = NSFetchRequest(entityName: "Moments")
        request.predicate = NSPredicate(format: "(category == %@)", MomentCategory.MetSomeone.rawValue)
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error)
        
        return tripsArray!.count
    }

    /**
     *
     *  Gets the total number of restaurants visited so far
     *
    */
    func getNumberOfRestaurants() -> Int{

        let request = NSFetchRequest(entityName: "Moments")
        request.predicate = NSPredicate(format: "(category == %@)", MomentCategory.Restaurant.rawValue)
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error)
        
        return tripsArray!.count
    }
    
    
    
    /*********************************************
    *
    *  MARK: Setter Methods
    *
    ***/
    
    func setUserName(newUserName : String){
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(newUserName, forKey: "username")
        
        userDefaults.synchronize()
    }
    
    func setUserProfileImage(newProfileImage: UIImage){
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        let imageDataRepresentation = UIImageJPEGRepresentation(newProfileImage, 1.0)
        
        userDefaults.setObject(imageDataRepresentation, forKey: "userProfileImage")
        
        userDefaults.synchronize()
    }
    
    func changePhotoGallerySavingPolicy(shouldSave: Bool){
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(shouldSave, forKey: "galleryPhotoSavingOption")
        
        userDefaults.synchronize()
    }
    
    
    /*********************************************
    *
    *  MARK: Deletion Methods
    *
    ***/
    
    /**
     *
     *  Deletes all the trips stored on the Persistent Store.
     *  Use it wisely.
     *
    */
    func deleteAllTrips(){
        
        let request = NSFetchRequest(entityName: "Trip")
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error) as! [Trip]
        
        for trip in tripsArray{
            self.managedObjectContext?.deleteObject(trip)
        }
        
        self.saveContext()
    }
    
    
    /**
     *
     *  Delete a specific Trip from the Persistent Store
     *
     *  :param: trip The trip to be deleted
     *
    */
    func deleteTrip(trip: Trip){
        
        self.managedObjectContext?.deleteObject(trip)
        self.saveContext()
    }
    
    func deleteTrip(destination: String, withBeginDate beginDate: NSDate, andEndDate endDate: NSDate) {
        
        let request = NSFetchRequest(entityName: "Trip")
        var error : NSError?
        
        request.predicate = NSPredicate(format: "destination == %@ AND beginDate == %@ AND endDate == %@", destination, beginDate, endDate)
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error) as! [Trip]
        
        self.managedObjectContext?.deleteObject(tripsArray[0])
        self.saveContext()
    }
}