//
//  ConnectionClient.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/9/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

class ConnectionClient: NSObject {
    
    // Shared session
    var session: NSURLSession
    
    // Facebook manager 
    let facebookManager = FBSDKLoginManager()
    
    // Singleton instance because all the network flows will need this class
    // to do the operations
    class func sharedInstance() -> ConnectionClient {
        
        struct Singleton {
            static var sharedInstance = ConnectionClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // Initialize the class
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //MARK: POST Method
    func doPOSTwithMethod(method: String!, ofBaseUrl baseUrl: String!, withRequestContent content: [String:String], andWithBody body: String!, isFromUdacity isUdacity: Bool?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let urlString = baseUrl + method
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        for(key, value) in content {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.HTTPBody = body!.dataUsingEncoding(NSUTF8StringEncoding)!
        
        session.dataTaskWithRequest(request) { (data, result, error) in
            
            // verify if any error occurs
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            // remove the first 5 characters from udaciy response like said in the documentation
            // "FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE."
            var newData = data
            
            if isUdacity! {
                newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
            }
            
            let json: AnyObject!
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(newData!, options: NSJSONReadingOptions.AllowFragments)
            } catch {
                json = nil
            }
            
            // send the response to be handled outside
            completionHandler(result: json, error: nil)
            
        }.resume()
    }
    
    //MARK: GET Method
    func doGETwithMethod(method: String!, ofBaseUrl baseUrl: String!, withRequestContent content: [String:String], isFromUdacity isUdacity: Bool?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let urlString = baseUrl + method
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        for(key, value) in content {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        session.dataTaskWithRequest(request) { (data, result, error) in
            
            // verify if any error occurs
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            // remove the first 5 characters from udaciy response like said in the documentation
            // "FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE."
            var newData = data
            
            if isUdacity! {
                newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
            }
            
            let json: AnyObject!
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(newData!, options: NSJSONReadingOptions.AllowFragments)
            } catch {
                json = nil
            }

            // send the response to be handled outside
            completionHandler(result: json, error: nil)
            
        }.resume()
    }
    
    //MARK: DELETE Method
    func doDELETEwithMethod(method: String!, ofBaseUrl baseUrl: String!, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let urlString = baseUrl + method
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        session.dataTaskWithRequest(request) { (data, result, error) in
            
            // verify if any error occurs
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
            
            let json: AnyObject!
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(newData!, options: NSJSONReadingOptions.AllowFragments)
            } catch {
                json = nil
            }
            
            // send the response to be handled outside
            completionHandler(result: json, error: nil)
            
        }.resume()
    }
}