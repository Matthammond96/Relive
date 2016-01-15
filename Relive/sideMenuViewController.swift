
import Foundation
import UIKit

let radiusValue = "1"

class sideMenuViewController: UITableViewController {
    
    //IBoutlet
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var CurrentPosLabel: UILabel!
    
    //IBAction
    @IBAction func radiusSlider(sender: UISlider) {
        if radiusData.locationRequired == true {
            radiusData.radiusValue = Double(sender.value)
            radiusLabel.text = "Radius: \(sender.value)km"
            NSNotificationCenter.defaultCenter().postNotificationName(radiusValue, object: self)
        } else {
            sender.alpha = 0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Slider No Location Control
        if radiusData.locationRequired == false {
            CurrentPosLabel.text = "Your Location is Required"
            radiusLabel.text = "Radius: "
        }
        
        //Stop Table View Scroll
        if (sideMenuTableView.contentSize.height < sideMenuTableView.frame.size.height) {
            sideMenuTableView.scrollEnabled = false
        }
        else {
            sideMenuTableView.scrollEnabled = true
        }
    }
    
    //Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuSettingsSegue" {
            _ = segue.destinationViewController as! settingsViewController
        }
        if segue.identifier == "menuLogoutSegue" {
            _ = segue.destinationViewController as! menuViewController
        }
        if segue.identifier == "postViewController" {
            _ = segue.destinationViewController as! postMemoryViewController
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        //Post A Memory
        if row == 1 {
            let alertController = UIAlertController(title: "Under Development", message: "We are currently developing the 'save a memory' page, however we have realised a visual prototype to gain feedback on. Do you wish to continue?", preferredStyle: .Alert)
            
            // Initialize Actions
            let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
                self.performSegueWithIdentifier("postViewController", sender: self)
            }
            
            let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            // Add Actions
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            
            // Present Alert Controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if row == 2 {
                let alertController = UIAlertController(title: "Under Development", message: "We are currently developing the 'save a memory' page, until this page is complete 'Your Memories' will have no data.", preferredStyle: .Alert)
                
                // Initialize Actions
                let yesAction = UIAlertAction(title: "Understood!", style: .Default) { (action) -> Void in
                    
                }
                
                // Add Actions
                alertController.addAction(yesAction)
                
                // Present Alert Controller
                self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if row == 4 {
            let alert = UIAlertView()
            alert.title = "This is a prototype of the settings page!"
            alert.message = "This is only a visual prototype and does not currently have an funcationality asigned to it!"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            //performSegueWithIdentifier("menuSettingsSegue", sender: self)
        }
        
        if row == 5 {
            performSegueWithIdentifier("menuLogoutSegue", sender: self)
        }
    }
}