
import Foundation
import UIKit

let radiusValue = "1"
let closeVC = "1"
let yourMemoriesVC = "1"

class sideMenuViewController: UITableViewController {
    
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBAction func radiusSlider(sender: UISlider) {
        radiusData.radiusValue = Double(sender.value)
        radiusLabel.text = "Radius: \(sender.value)"
        NSNotificationCenter.defaultCenter().postNotificationName(radiusValue, object: self)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        //Post A Memory
        if row == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(closeVC, object: self)
        }
        
        if row == 2 {
            NSNotificationCenter.defaultCenter().postNotificationName(yourMemoriesVC, object: self)
        }
        
        if row == 4 {
            performSegueWithIdentifier("menuSettingsSegue", sender: self)
        }
        
        if row == 5 {
            performSegueWithIdentifier("menuLogoutSegue", sender: self)
        }
    }
}