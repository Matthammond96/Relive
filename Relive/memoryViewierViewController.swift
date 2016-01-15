
import Foundation
import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class memoryViewierViewController: UIViewController {
    
    //Varibles
    var cellData: JSONDataClass!
    var imageNumber = Int(1)
    var distance: CLLocationDistance!
    var locationManager = CLLocationManager()
    var userLocation: CLLocation!
    var mapRegion: MKCoordinateRegion!
    var mapFakeRegion: MKCoordinateRegion!
    var firstSwipe = false
    
    //IBOutlets
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var swipeHelpLebel: UILabel!
    @IBOutlet weak var swipeHelpView: UIView!
    @IBOutlet weak var imageProgress: UIProgressView!
    
    //Label IBOutlets
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //IBActions
    @IBAction func mapImageSwitcher(sender: UISwitch) {
        if sender.on == true {
            mapView.alpha = 1
            mapView.setRegion(mapRegion, animated: true)
            imageViewer.alpha = 0
            imageProgress.alpha = 0
            swipeHelpLebel.alpha = 0
            swipeHelpView.alpha = 0
        } else {
            mapView.setRegion(mapFakeRegion, animated: true)
            mapView.alpha = 0
            imageViewer.alpha = 1
            if firstSwipe == false {
                swipeHelpLebel.alpha = 1
                swipeHelpView.alpha = 1
            } else {
                imageProgress.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Manager
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //Set Annotations
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(cellData.latitude), CLLocationDegrees(cellData.longitude))
        self.mapView.addAnnotation(annotation)
        
        //Gesture
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let backSwipe = UISwipeGestureRecognizer(target: self, action: Selector("backSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        backSwipe.direction = .Right
        imageViewer.userInteractionEnabled = true
        imageViewer.addGestureRecognizer(leftSwipe)
        imageViewer.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(backSwipe)
        
        //Set image on load
        downloadImage(cellData.m1) { image in
            self.imageViewer.image = image
        }
        
        //Not sure what this is doing something to do with the scroll view
        scrollView.contentSize.height = 5000
        view.addSubview(scrollView)
        
        //Adding Label Data
        titleLabel.text = cellData.memoryTitle
        descriptionTextView.text = cellData.memoryDescription
        typeLabel.text = "Type: \(cellData.memoryType)"
        friendsLabel.text = "Friends: \(cellData.taggedFriends)"
        userLabel.text = "Memory By: \(cellData.postUser)"
    }
    
    func backSwipes(sender:UIGestureRecognizer) {
        performSegueWithIdentifier("discoverSegue", sender: self)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
            firstSwipe = true
            swipeHelpLebel.alpha = 0
            swipeHelpView.alpha = 0
            imageProgress.alpha = 1
            
            if imageProgress.progress < 1 {
                imageProgress.progress =  imageProgress.progress + 0.25
            }
            
            if imageNumber < cellData.media.count {
                imageNumber = imageNumber + 1
                print(imageNumber)
                //print("\(cellData.m)\(imageNumber)")
            }
            if imageNumber == 1 {
                downloadImage(cellData.m1) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 2 {
                downloadImage(cellData.m2) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 3 {
                downloadImage(cellData.m3) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 4 {
                downloadImage(cellData.m4) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 5 {
                downloadImage(cellData.m5) { image in
                    self.imageViewer.image = image
                }
            }
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            
            if imageProgress.progress > 0.1 {
                imageProgress.progress =  imageProgress.progress - 0.25
            }
            
            if imageNumber > 1 {
                imageNumber = imageNumber - 1
            }
            if imageNumber == 1 {
                downloadImage(cellData.m1) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 2 {
                downloadImage(cellData.m2) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 3 {
                downloadImage(cellData.m3) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 4 {
                downloadImage(cellData.m4) { image in
                    self.imageViewer.image = image
                }
            }
            if imageNumber == 5 {
                downloadImage(cellData.m5) { image in
                    self.imageViewer.image = image
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discoverSegue" {
            _ = segue.destinationViewController as! SWRevealViewController
        }
    }
}

extension memoryViewierViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        
        let currentCLLocation: CLLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let distanceCalc: CLLocationDistance = (cellData.cacheCLLocation.distanceFromLocation(currentCLLocation)) / 1000
        let regionSpan = MKCoordinateSpanMake(distanceCalc/70 , distanceCalc/70)
        let userRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), span: regionSpan)
        let fakeSpan = MKCoordinateSpanMake(distanceCalc/10 , distanceCalc/10)
        let fakeRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), span: fakeSpan)
        
        userLocation = currentCLLocation
        distance = distanceCalc
        mapFakeRegion = fakeRegion
        mapRegion = userRegion
        
    }
}
