//
//  ConnectionParse.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/11/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

// Extension responsible to implement the functions
// to do network operations with PARSE API
//
extension ConnectionClient {
    
    //MARK: Get StudentLocations list
    
    func parseGetStudentLocations(completionHandler: (result: AnyObject!, error: String?) -> Void) {
    
        let parameters = [
            ParseAPI.ParameterLimit : "100",
            ParseAPI.ParameterOrder : "-\(ParseAPI.TagUpdatedAt)"
        ]
        
        let requestContent = [
            ParseAPI.RequestParamParseAppID : ParseAPI.ParseApplicationID,
            ParseAPI.RequestParamAPIKey : ParseAPI.RESTAPIKey
        ]
        
        let baseUrl = ParseAPI.BaseUrl
        let method = ParseAPI.StudentLocationMethod + formatParameters(parameters)
        
        doGETwithMethod(method, ofBaseUrl: baseUrl, withRequestContent: requestContent, isFromUdacity: false) { (result, error) in
            
            // parsing the JSON
            if let json = result as? [String:AnyObject] {
                
                guard let array = json[ParseAPI.TagResults] as? [[String:AnyObject]] else {
                    completionHandler(result: false, error: "Failed to get student location list!")
                    return
                }
                
                for item in array {
                    
                    let studentDictionary = item as [String:AnyObject]
                    
                    // parse the studentlocation
                    let student = StudentLocation(dictionary: studentDictionary)
                    
                    // add to the array
                    StudentManager.sharedInstance().studentArray.append(student)
                }
                
                // send the success response
                completionHandler(result: true, error: nil)
                
                
            } else {
                completionHandler(result: false, error: "Failed to get student location list!")
            }
            
        }
    }
    
    //MARK: Post Student location
    
    func parsePostStudentLocation(student: StudentLocation, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        let requestContent = [
            ParseAPI.RequestParamParseAppID : ParseAPI.ParseApplicationID,
            ParseAPI.RequestParamAPIKey : ParseAPI.RESTAPIKey,
            ParseAPI.RequestParamContentType : ParseAPI.ContentJSON
        ]
        
        let baseUrl = ParseAPI.BaseUrl
        let method = ParseAPI.StudentLocationMethod
        
        let body = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}"
        
        doPOSTwithMethod(method, ofBaseUrl: baseUrl, withRequestContent: requestContent, andWithBody: body, isFromUdacity: false) { (result, error) in
            
            // parsing the JSON
            if let json = result as? [String:AnyObject] {
                
                guard let _ = json[ParseAPI.TagCreatedAt] as? String else {
                    completionHandler(result: false, error: "Failed to post student location!")
                    return
                }
                
                guard let _ = json[ParseAPI.TagObjectId] as? String else {
                    completionHandler(result: false, error: "Failed to post student location!")
                    return
                }

                // send the success response
                completionHandler(result: true, error: nil)
                
                
            } else {
                completionHandler(result: false, error: "Failed to post student location!")
            }

        }
    }
    
    //MARK: Help functions
    
    // convert a dictionary with the parameters to a string for a url
    private func formatParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}
