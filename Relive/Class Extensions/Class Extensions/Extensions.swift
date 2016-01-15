
import Foundation
import UIKit
import Alamofire

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

func downloadImage(url: String, completion: (image: UIImage) -> Void) {
    Alamofire.request(.GET, url).response { _, _, data, _ in
        if let data = data {
            let image = UIImage(data: data)
            completion(image: image!)
            print(url)
        }
    }
}