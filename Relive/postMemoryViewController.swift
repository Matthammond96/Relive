
import Foundation
import UIKit

class postMemoryViewController: UIViewController {
    
    //Varibles
    var typeArray = ["Weddings", "Stag", "Hen", "Birthdays", "Holidays", "Other"]
    
    //IBoutlets
    @IBOutlet weak var DescriptionTextView: UITextView!
    @IBOutlet weak var SavePostFormTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DescriptionTextView.layer.cornerRadius = 5
        DescriptionTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        DescriptionTextView.layer.borderWidth = 0.5
        DescriptionTextView.clipsToBounds = true
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
}

extension postMemoryViewController: UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
}

extension postMemoryViewController: UIPickerViewDataSource {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
}