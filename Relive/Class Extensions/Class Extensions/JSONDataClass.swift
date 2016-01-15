
import Foundation
import CoreLocation
import SwiftyJSON

class JSONDataClass {
    
    //ID 
    var ID: Int!
    
    //Location MetaData
    var postUser: String!
    var memoryTitle: String!
    var memoryDescription: String!
    var memoryType: String!
    //var memoryEmotion: String!
    var taggedFriends: String!
    
    //Location LocationalData
    //var memoryLocation: CLLocationCoordinate2D
    var cacheCLLocation: CLLocation!
    var distance: Double?
    var latitude: Double!
    var longitude: Double!
    
    //MultiMedia AddressData
    var m1: String!
    var m2: String!
    var m3: String!
    var m4: String!
    var m5: String!
    var media: [AnyObject]
    
    //Writing to varibles
    init(json: JSON) {
        //ID
        ID = json["id"].intValue
        
        //Content
        postUser = json["content"]["user"].stringValue
        memoryTitle = json["content"]["title"].stringValue
        memoryDescription = json["content"]["description"].stringValue
        memoryType = json["content"]["type"].stringValue
        //memoryEmotion = json["emotion"].stringValue
        taggedFriends = json["content"]["friends"].stringValue
        
        //memoryLocation = CLLocationCoordinate2D(latitude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue)
        latitude = json["content"]["latitude"].doubleValue
        longitude = json["content"]["longitude"].doubleValue
        cacheCLLocation = CLLocation(latitude: json["content"]["latitude"].doubleValue, longitude: json["content"]["longitude"].doubleValue)
        
        media = [json["content"]["media"]["m1"].stringValue, json["content"]["media"]["m2"].stringValue, json["content"]["media"]["m3"].stringValue, json["content"]["media"]["m4"].stringValue, json["content"]["media"]["m5"].stringValue]
        m1 = json["content"]["media"]["m1"].stringValue
        m2 = json["content"]["media"]["m2"].stringValue
        m3 = json["content"]["media"]["m3"].stringValue
        m4 = json["content"]["media"]["m4"].stringValue
        m5 = json["content"]["media"]["m5"].stringValue
    }
}
