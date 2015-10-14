//
//  ConnectionUdacity.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/9/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

// Extension responsible to implement the functions
// to do network operations with UDACITY API
//
extension ConnectionClient {
    
    //MARK: Get user public information
    
    func udacityGetUserInformation(completionHandler: (result: AnyObject!, error: String?) -> Void) {
        let baseUrl: String = ConnectionClient.UdacityAPI.BaseUrl
        let method: String = ConnectionClient.UdacityAPI.UsersMethod + "/" + UserLogin.accountKey!
        
        let requestContent = [
            UdacityAPI.RequestParamContentType : UdacityAPI.ContentJSON
        ]
        
        doGETwithMethod(method, ofBaseUrl: baseUrl, withRequestContent: requestContent, isFromUdacity: true) { (result, error) in
            
            if let json = result as? [String:AnyObject] {
                
                if let error = json[UdacityAPI.TagError] as? String {
                    completionHandler(result: false, error: error)
                    
                } else {
                    
                    guard let user = json[UdacityAPI.TagUser] as? [String:AnyObject] else {
                        completionHandler(result: false, error: "Failed to get user information!")
                        return
                    }
                    
                    // save the user information
                    UserLogin.userFirstName = user[UdacityAPI.TagFirstName] as? String
                    UserLogin.userLastName = user[UdacityAPI.TagLastName] as? String
                    
                    // complete the process
                    completionHandler(result: true, error: nil)
                }
                
            } else {
                completionHandler(result: false, error: "Failed to get user information!")
            }
            
        }
    }
    
    //MARK: Login (Creating a Session)
    
    func udacityLogin(username: String!, password: String!, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        let body: String = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let baseUrl: String = ConnectionClient.UdacityAPI.BaseUrl
        let method: String = ConnectionClient.UdacityAPI.SessionMethod
        
        let requestContent = [
            UdacityAPI.RequestParamAccept : UdacityAPI.ContentJSON,
            UdacityAPI.RequestParamContentType : UdacityAPI.ContentJSON
        ]
        
        doPOSTwithMethod(method, ofBaseUrl: baseUrl, withRequestContent: requestContent, andWithBody: body, isFromUdacity: true) { (result, error) in
            self.handleRequest(result, error: error, completionHandler: completionHandler)
        }
    }
    
    //MARK: Login with Facebook (Creating a Session)
    
    func udacityLoginWithFacebook(accessToken: String!, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        let body: String = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken);\"}}"
        let baseUrl: String = ConnectionClient.UdacityAPI.BaseUrl
        let method: String = ConnectionClient.UdacityAPI.SessionMethod
        
        let requestContent = [
            UdacityAPI.RequestParamAccept : UdacityAPI.ContentJSON,
            UdacityAPI.RequestParamContentType : UdacityAPI.ContentJSON
        ]
        
        doPOSTwithMethod(method, ofBaseUrl: baseUrl, withRequestContent: requestContent, andWithBody: body, isFromUdacity: true) { (result, error) in
            self.handleRequest(result, error: error, completionHandler: completionHandler)
        }
    }
    
    //MARK: Logout
    
    func udacityLogout(completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        if UserLogin.loginType == UdacityAPI.LoginUdacity {
            let baseUrl: String = ConnectionClient.UdacityAPI.BaseUrl
            let method: String = ConnectionClient.UdacityAPI.SessionMethod
            
            doDELETEwithMethod(method, ofBaseUrl: baseUrl) { (result, error) in

                if let json = result as? [String:AnyObject] {
                
                    if let error = json[UdacityAPI.TagError] as? String {
                        completionHandler(result: false, error: error)
                    
                    } else {
                    
                        guard let _ = json[UdacityAPI.TagSession] as? [String:AnyObject] else {
                            completionHandler(result: false, error: "Failed to logout!")
                            return
                        }
                    
                        // complete the process
                        completionHandler(result: true, error: nil)
                    }
                
                } else {
                    completionHandler(result: false, error: "Failed to logout!")
                }
                
            }
            
        } else {
            facebookManager.logOut()
            completionHandler(result: true, error: nil)
        }
    }
    
    //MARK: Private functions
    
    // Handle the POST method respose
    private func handleRequest(result: AnyObject!, error: NSError?, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        if let json = result as? [String:AnyObject] {
            
            if let error = json[UdacityAPI.TagError] as? String {
                completionHandler(result: false, error: error)
                
            } else {
                
                guard let account = json[UdacityAPI.TagAccount] as? [String:AnyObject] else {
                    completionHandler(result: false, error: "Failed to login!")
                    return
                }
                
                guard let registered = account[UdacityAPI.TagRegistered] as? Bool where registered else {
                    completionHandler(result: false, error: "Failed to login!")
                    return
                }
                
                // save the account key
                UserLogin.accountKey = account[UdacityAPI.TagKey] as? String
                
                guard let session = json[UdacityAPI.TagSession] as? [String:AnyObject] else {
                    completionHandler(result: false, error: "Failed to login!")
                    return
                }
                
                // save the session id
                UserLogin.sessionId = session[UdacityAPI.TagId] as? String
                
                // get the user information
                udacityGetUserInformation(completionHandler)
            }
            
        } else {
            completionHandler(result: false, error: "Failed to login!")
        }
    }
}