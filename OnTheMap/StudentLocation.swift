//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/11/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    // Student information
    var objectId: String? = nil
    var uniqueKey: String? = nil
    
    // personal
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    
    // location
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    
    // dates
    var createdAt: String? = nil
    var updatedAt: String? = nil
   
    // Construct from a dictionary
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ConnectionClient.ParseAPI.TagObjectId] as? String
        uniqueKey = dictionary[ConnectionClient.ParseAPI.TagUniqueKey] as? String
        
        firstName = dictionary[ConnectionClient.ParseAPI.TagFirstName] as? String
        lastName = dictionary[ConnectionClient.ParseAPI.TagLastName] as? String
        mapString = dictionary[ConnectionClient.ParseAPI.TagMapString] as? String
        mediaURL = dictionary[ConnectionClient.ParseAPI.TagMediaURL] as? String
        
        createdAt = dictionary[ConnectionClient.ParseAPI.TagCreatedAt] as? String
        updatedAt = dictionary[ConnectionClient.ParseAPI.TagUpdatedAt] as? String
        
        latitude = dictionary[ConnectionClient.ParseAPI.TagLatitude] as? Double
        longitude = dictionary[ConnectionClient.ParseAPI.TagLongitude] as? Double
    }
}
