
import Foundation
import CoreLocation
import SwiftyJSON

class JSONDataClass {
    
    //Location MetaData
    var postUser: String!
    var memoryTitle: String!
    var memoryDescription: String!
    var memoryType: String!
    //var memoryEmotion: String!
    //var taggedFriends: String!
    
    //Location LocationalData
    //var memoryLocation: CLLocationCoordinate2D
    
    //MultiMedia AddressData
    //var media1: String!
    //var media2: String!
    //var media3: String!
    //var media4: String!
    //var media5: String!
    
    //Writing to varibles
    init(json: JSON) {
        postUser = json["user"].stringValue
        memoryTitle = json["title"].stringValue
        memoryDescription = json["description"].stringValue
        memoryType = json["type"].stringValue
        //memoryEmotion = json["emotion"].stringValue
        //taggedFriends = json["friends"].stringValue
        
        //memoryLocation = CLLocationCoordinate2D(latitude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue)
        
        //media1 = json["media1"].stringValue
        //media2 = json["media2"].stringValue
        //media3 = json["media3"].stringValue
        //media4 = json["media4"].stringValue
        //media5 = json["media5"].stringValue
    }
}
