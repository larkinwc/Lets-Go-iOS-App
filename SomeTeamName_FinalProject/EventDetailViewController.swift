//
//  EventDetailViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by Williams-Capone, Larkin on 11/30/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class EventDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()


    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var myNavBar: UINavigationBar!
    
    
    
    
    
    
    
    
    @IBOutlet weak var heartImage: UIImageView!
    
    
    
    //@IBOutlet weak var heartImage: UIBarButtonItem!
    
    
    
    @IBAction func heartButton(_ sender: Any) {
        animate(imageView: heartImage, images: heartImages)
        addToFavorites()

    }
    
    
    var heartImages: [UIImage] = []
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            imageArray.append(image)
        }
        return imageArray
    }
    
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
    
    
    

    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        heartImages = createImageArray(total: 94, imagePrefix: "heart")
        
        
        
        
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
        mapView.delegate = self;
        mapView.showsUserLocation = true
        //mapView.userTrackingMode = .follow //Moves view to user position
        let lat = (selectedEvent?.value(forKey: "lat") as! NSString).doubleValue // have to cast to NSString and get double value of rather than directly to double
        let long = (selectedEvent?.value(forKey: "long") as! NSString).doubleValue
        let name = selectedEvent?.value(forKey: "name") as! String
        
        let annotation = eventLocation(title: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        mapView.addAnnotation(annotation)
        let date =  selectedEvent?.value(forKey: "date") as? String
        let time =  selectedEvent?.value(forKey: "time") as? String
        dateAndTime.text = date! + " - " + time!
        eventName.text = selectedEvent?.value(forKey: "name") as? String
        eventDescription.text = selectedEvent?.value(forKey: "eventdescription") as? String
        
        let imageURl = URL(string: selectedEvent?.value(forKey: "photo") as! String)
        let data = try? Data(contentsOf: imageURl!)
        detailImage.image = UIImage(data: data!)
        
        var isFavorite = selectedEvent?.value(forKey: "favorited")

        /* let date =  selectedEvent["date"] as? String
        let time =  selectedEvent["time"] as? String
        dateAndTime.text = date! + " - " + time!
        eventName.text = selectedEvent["name"] as? String
        eventDescription.text = selectedEvent["description"] as? String
        */
        //eventDescription.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        addToFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorites")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            favorites = results
        }
    }
    
    func addToFavorites() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: managedContext)
        
        let favorite = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        favorite.setValue(selectedEvent?.value(forKey: "cat"), forKey: "cat")
        favorite.setValue(selectedEvent?.value(forKey: "date"), forKey: "date")
        favorite.setValue(selectedEvent?.value(forKey: "duration"), forKey: "duration")
        favorite.setValue(selectedEvent?.value(forKey: "eventdescription"), forKey: "eventdescription")
        favorite.setValue(selectedEvent?.value(forKey: "lat"), forKey: "lat")
        favorite.setValue(selectedEvent?.value(forKey: "long"), forKey: "long")
        favorite.setValue(selectedEvent?.value(forKey: "name"), forKey: "name")
        favorite.setValue(selectedEvent?.value(forKey: "photo"), forKey: "photo")
        favorite.setValue(selectedEvent?.value(forKey: "time"), forKey: "time")
        favorite.setValue(selectedEvent?.value(forKey: "favorited"), forKey: "favorited")
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FavoriteIcon"), style: .plain, target: self, action: #selector(EventDetailViewController.favoriteButton(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FavoriteIcon"), style: .done, target: self, action: #selector(EventDetailViewController.favoriteButton(_:)))
        
        print(self)
        print(self.navigationItem)
        print(self.navigationItem.rightBarButtonItem)
        print(self.myNavBar)
        
        /*
        var items = self.myNavBar.items
        items![2] = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(ViewController.playButtonTapped(_:)))
        isPlaying = false
        buttonStatusLabel.text = "On pause..."
        self.myToolBar.setItems(items, animated: true)
        */
        
        print("Added \(selectedEvent!.value(forKey: "name")) to favorites")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    /*
    //BROKEN, doesnt work
    func removeFromFavorites() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        userFetch.fetchLimit = 1
        
        userFetch.predicate = NSPredicate(format: "name = %@", selectedEvent?.value(forKey: "name") as! String )
        managedContext.delete(selectedEvent!)
        //favorites.remove(at: Int)
        
        do {
            try managedContext.save()
            print("Deleted")
        }
        catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
