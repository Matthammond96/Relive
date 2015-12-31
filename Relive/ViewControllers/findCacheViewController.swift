
import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class findCacheViewController: UIViewController {
    
    //Varibles
    var userCurrentLocation: CLLocation!
    var locationManager: CLLocationManager = CLLocationManager()
    var cacheData = [JSONDataClass]()
    var selectedCell: JSONDataClass!
    
    //IBOutlets
    @IBOutlet weak var menuShow: UIBarButtonItem!

    @IBOutlet weak var locationTableView: UITableView!
    
    //IBActions
    @IBAction func addPostButton(sender: AnyObject) {
        performSegueWithIdentifier("postViewController", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSNotificationCenter
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "radiusUpdated", name: radiusValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "postMemoryFunc", name: closeVC, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "yourMemoriesFunc", name: yourMemoriesVC, object: nil)
        
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
                    
                    for title in self.cacheData {
                        print(title.memoryTitle)
                    }
                }
                
        }
        
        //Next Code Block

        
    }
    
    //NSNotification Functions
    func postMemoryFunc() {
        performSegueWithIdentifier("postViewController", sender: self)
    }
    
    func yourMemoriesFunc() {
        //performSegueWithIdentifier("yourMemoriesSegue", sender: self)
    }
    
    func radiusUpdated() {
        locationTableView.reloadData()
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
        //if segue.identifier == "yourMemoriesSegue" {
            
        //}
    }
    
}

//User location Delegate
extension findCacheViewController: CLLocationManagerDelegate {
    
    //Users Location Did Up Data
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        
        locationTableView.reloadData()  
        userCurrentLocation = currentLocation
        //UserLocation Did Update
    }
    
}

//Table Data Source
extension findCacheViewController: UITableViewDataSource {
    
    //Number Of Rows (Return Value)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if userCurrentLocation == nil {
          //  return 1
        //} else {
            return cacheData.count
        //}
    }
    
    //Table Content
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCellWithIdentifier("Cell")
        let titleLabelCell = cell?.viewWithTag(1) as! UILabel
        let typeLabelCell = cell?.viewWithTag(2) as! UILabel
        let distanceLabelCell = cell?.viewWithTag(3) as! UILabel
        let cellData = cacheData[indexPath.row]
        
        if userCurrentLocation == nil {
            titleLabelCell.text = "Location Required"
            typeLabelCell.text = ""
            distanceLabelCell.text = ""
        } else {
            
            
            titleLabelCell.text = "\(cellData.memoryTitle)"
            typeLabelCell.text = "\(cellData.memoryType)"
        }
        
        return cell!
    }
}

//Table Delegate
extension findCacheViewController: UITableViewDelegate {
    
    //Row Height Based On Condition
    //func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let cellData = cacheData[indexPath.row]
        //return 80
        //if conditions {
            
        //}
    //}
    
    //Selected Cell Segue Function
    func tableView(collection: UITableView, selectedItemIndex: NSIndexPath) {
        self.performSegueWithIdentifier("viewMemorySegue", sender: self)
    }
}
