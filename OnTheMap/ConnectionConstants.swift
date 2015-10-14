//
//  ConnectionConstants.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/9/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// extension responsible to hold all the constants of the application
extension ConnectionClient {
    
    struct UserLogin {
        //MARK: User Login information
        static var accountKey: String?
        static var sessionId: String?
        static var userFirstName: String?
        static var userLastName: String?
        static var loginType: Int?
    }
    
    struct UdacityAPI {
        //MARK: URL
        static let BaseUrl: String = "https://www.udacity.com/api"
        static let RegistrationUrl: String = "https://www.udacity.com/account/auth#!/signin"
        
        //MARK: Methods
        static let SessionMethod: String = "/session"
        static let UsersMethod: String = "/users"
        
        //MARK: Udacity information
        static let RequestParamAccept = "Accept"
        static let RequestParamContentType = "Content-Type"
        static let ContentJSON = "application/json"
        
        //MARK: JSON tags
        static let TagError: String = "error"
        static let TagKey: String = "key"
        static let TagId: String = "id"
        static let TagAccount: String = "account"
        static let TagSession: String = "session"
        static let TagRegistered: String = "registered"
        static let TagUser: String = "user"
        static let TagLastName: String = "last_name"
        static let TagFirstName: String = "first_name"
        
        //MARK: Login types
        static let LoginUdacity: Int = 1
        static let LoginFacebook: Int = 2
    }
    
    struct ParseAPI {
        //MARK: URL
        static let BaseUrl: String = "https://api.parse.com/1/classes"
        
        //MARK: Method
        static let StudentLocationMethod: String = "/StudentLocation"
        
        //MARK: Parse information
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let RequestParamParseAppID = "X-Parse-Application-Id"
        static let RequestParamAPIKey = "X-Parse-REST-API-Key"
        static let RequestParamContentType = "Content-Type"
        static let ContentJSON = "application/json"
        
        //MARK: Get optional parameters
        static let ParameterLimit: String = "limit"
        static let ParameterOrder: String = "order"
        
        //MARK: JSON tags
        static let TagResults: String = "results"
        static let TagCreatedAt: String = "createdAt"
        static let TagFirstName: String = "firstName"
        static let TagLastName: String = "lastName"
        static let TagLatitude: String = "latitude"
        static let TagLongitude: String = "longitude"
        static let TagMapString: String = "mapString"
        static let TagMediaURL: String = "mediaURL"
        static let TagObjectId: String = "objectId"
        static let TagUniqueKey: String = "uniqueKey"
        static let TagUpdatedAt: String = "updatedAt"
    }
}