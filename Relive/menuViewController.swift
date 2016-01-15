
import UIKit

class menuViewController: UIViewController {
    
    //IBAction
    @IBAction func saveMemoryButton(sender: AnyObject) {
        let alertController = UIAlertController(title: "Under Development", message: "We are currently developing the 'save a memory' page, however we have realised a visual prototype to gain feedback on. Do you wish to continue?", preferredStyle: .Alert)
        
        // Initialize Actions
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
            self.performSegueWithIdentifier("saveAMemorySegue", sender: self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in}
        
        // Add Actions
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        // Present Alert Controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveAMemorySegue" {
            _ = segue.destinationViewController as! postMemoryViewController
        }
    }
}