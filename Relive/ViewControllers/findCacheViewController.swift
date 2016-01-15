
import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class findCacheViewController: UIViewController {
    
    //Varibles
    var userCurrentLocation: CLLocation!
    var userLocRegion: MKCoordinateRegion?
    var locationManager = CLLocationManager()
    var cacheData = [JSONDataClass]()
    var selectedCell: JSONDataClass!
    var users = [String]()
    var startup = true
    var visibleCells = 0
    
    //IBOutlets
    @IBOutlet weak var menuShow: UIBarButtonItem!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var updateRadiusLabel: UILabel!
    @IBOutlet weak var updateRadiusView: UIView!
    
    //IBActions
    @IBAction func addPostButton(sender: AnyObject) {
        let alertController = UIAlertController(title: "Under Development", message: "We are currently developing the 'save a memory' page, however we have realised a visual prototype to gain feedback on. Do you wish to continue?", preferredStyle: .Alert)
        
        // Initialize Actions
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
            self.performSegueWithIdentifier("postViewController", sender: self)
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in }
        // Add Actions
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        // Present Alert Controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSNotificationCenter
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "radiusUpdated", name: radiusValue, object: nil)
        
        //CLLocation Manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Menu Reveal Segue
        if self.revealViewController() != nil {
            menuShow.target = self.revealViewController()
            menuShow.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //JSON Alamofire Request
        Alamofire.request(.GET, "http://midlandgates.co.uk/JSON/reliveCacheData.json")
            .response { request, response, data,  error in
                
                if let data = data {
                    let json = JSON(data:data)
                    
                    
                    for locationData in json {
                        let locationDataJSON = JSONDataClass(json: locationData.1)
                        self.cacheData.append(locationDataJSON)
                        self.locationTableView.reloadData()
                    }
                    
                    //Data Test Loop
                    for title in self.cacheData {
                        print(title.media.count)
                        print(title.memoryTitle)
                    }
                    
                    var counter = 0
                    
                    let someJSON = JSON(data: data)
                    
                    for user in someJSON.arrayValue {
                        let userName = user["content"]["media"].stringValue
                        self.users.append(userName)
                    }
                    
                    print("User count:\(self.users.count)")
                    
                    //Anotation Locations
                    for location in self.cacheData {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(location.latitude), CLLocationDegrees(location.longitude))
                        self.mainMapView.addAnnotation(annotation)
                    }
                    
                    for region in self.cacheData {
                        let regionCLLoation = CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude)
                        let createRegion = CLCircularRegion(center: regionCLLoation, radius: 100, identifier: region.memoryType)
                        self.locationManager.startMonitoringForRegion(createRegion)
                    }
                }
                
        }
        
        //Next Code Block

    }
    
    //NSNotification Functions
    func radiusUpdated() {
        locationTableView.reloadData()
        mainMapView.setRegion(userLocRegion!, animated: true)
        visibleCells = 0
    }
    
    //Pepare For Segueways
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postViewController" {
            _ = segue.destinationViewController as! postMemoryViewController
        }
        if segue.identifier == "viewMemorySegue" {
            let viewMemoryVC = segue.destinationViewController as! memoryViewierViewController
            viewMemoryVC.cellData = selectedCell!
        }
        if segue.identifier == "yourMemoriesSegue" {
            _ = segue.destinationViewController as! yourMemoriesViewController
        }
    }
    
}

//User location Delegate
extension findCacheViewController: CLLocationManagerDelegate {
    
    //Users Location Did Up Data
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        let sliderVal = radiusData.radiusValue / 70
        
        let regionSpan = MKCoordinateSpanMake(sliderVal, sliderVal)
        let userRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), span: regionSpan)
        
        if radiusData.locationRequired == false {
            radiusData.locationRequired = true
            print(radiusData.locationRequired)
        }
        
        locationTableView.reloadData()
        userCurrentLocation = currentLocation
        userLocRegion = userRegion
        mainMapView.setRegion(userLocRegion!, animated: true)
    }
    
    //Region Monitoring - Enter
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region: \(region.identifier)")
        let alertController = UIAlertController(title: "Cache Found Within 100m of you!", message: "Currently underdevelopement therefore the funcationality doesnt yet work, to view the next page please go find a spot on the discover table", preferredStyle: .Alert)
        
        // Initialize Actions
        let yesAction = UIAlertAction(title: "Ok!", style: .Default) { (action) -> Void in
            //self.performSegueWithIdentifier("postViewController", sender: self)
            print("Ok, Understood")
        }
        // Add Actions
        alertController.addAction(yesAction)
        // Present Alert Controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Region Monitoring - Enter
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region: \(region.identifier)")
    }
    
    
}

//Table Data Source
extension findCacheViewController: UITableViewDataSource {
    
    //Number Of Rows (Return Value)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if userCurrentLocation == nil {
            return 1
        } else {
            return cacheData.count
        }
    }
    
    //Table Content
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCellWithIdentifier("Cell")
        let titleLabelCell = cell?.viewWithTag(1) as! UILabel
        let typeLabelCell = cell?.viewWithTag(2) as! UIImageView
        let distanceLabelCell = cell?.viewWithTag(3) as! UILabel
        let typeOtherLabel = cell?.viewWithTag(4) as! UILabel
        
        if userCurrentLocation == nil {
            titleLabelCell.text = "Location Required"
            typeLabelCell.image = UIImage(named: "")
            distanceLabelCell.text = ""
        } else {
            let cellData = cacheData[indexPath.row]
            let distanceMaths: CLLocationDistance = (cellData.cacheCLLocation.distanceFromLocation(userCurrentLocation)) / 1000
            cellData.distance = distanceMaths
            
            distanceLabelCell.text = "Distance: \(Double(distanceMaths).roundToPlaces(1) )km"
            titleLabelCell.text = "\(cellData.memoryTitle)"
            if cellData.memoryType == "Stag" {
                typeLabelCell.image = UIImage(named: "iconTypes_07")
            }
            if cellData.memoryType == "Wedding" {
                typeLabelCell.image = UIImage(named: "iconTypes_09")
            }
            
            if cellData.memoryType == "Holiday" {
                typeLabelCell.image = UIImage(named: "iconTypes_06")
            }
            
            if cellData.memoryType == "Other" {
                typeLabelCell.image = UIImage(named: "iconTypes_03")
                typeLabelCell.alpha = 0
                typeOtherLabel.alpha = 1
            }
        }
        
        return cell!
    }
}

//Table Delegate
extension findCacheViewController: UITableViewDelegate {
    
    //Row Height Based On Condition
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //Reset value
        
        
        if userCurrentLocation != nil {
            let cellData = cacheData[indexPath.row]
            
           
            
            if cellData.distance < radiusData.radiusValue {
                visibleCells++
                return 80
            } else {
                if visibleCells == 0 {
                    UIView.animateWithDuration(1.5, animations: {
                        self.updateRadiusLabel.alpha = 1
                        self.updateRadiusView.alpha = 1
                    })
                } else {
                    UIView.animateWithDuration(1.5, animations: {
                        self.updateRadiusLabel.alpha = 0
                        self.updateRadiusView.alpha = 0
                    })
                }
                return 0
            }
        }
            return 80
    }
    
    //Select Function Based On Row Clicked
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if userCurrentLocation != nil {
            selectedCell = cacheData[indexPath.row]
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            performSegueWithIdentifier("viewMemorySegue", sender: self)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
