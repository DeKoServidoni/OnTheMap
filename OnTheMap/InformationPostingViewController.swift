//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation
import MapKit

// protocol responsible to communicate with the ViewController
// that call this view
protocol InformationPostingProtocol {
    func submitDone()
}

class InformationPostingViewController: UIViewController {
    
    //MARK: first part components
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var mapFindTextView: UITextView!
    @IBOutlet weak var labelText: UILabel!
    
    //MARK: second part components
    @IBOutlet weak var addInfoTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitButtonBorder: UIImageView!
    
    // Protocol reference
    var delegate: InformationPostingProtocol?
    
    // Searched coordinate
    var coordinates: CLLocationCoordinate2D!
    
    // loading dialog
    var loadingDialog = LoadingDialog()
    
    // textField delegate
    var textDelegate: InformationTextViewDelegate!
    
    //MARK: Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDelegate = InformationTextViewDelegate()
        
        mapFindTextView.delegate = textDelegate
        addInfoTextView.delegate = textDelegate
        
        // show the initial container
        showFirstContainer()
    }
    
    //MARK: Action functions
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Find the location from the user entered string
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        // veryfi if the location to be searched is empty or not
        guard !mapFindTextView.text.isEmpty else {
            showAlertWith("Please enter some location")
            return
        }
        
        loadingDialog.showLoading(view)
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(mapFindTextView.text!) { (placemarks, error) in
            self.loadingDialog.dismissLoading()
            
            if error != nil {
                self.showAlertWith(error?.description)
                
            } else {
                
                // get the first location of the array
                if let placemark = placemarks?.first {
                    
                    self.coordinates = placemark.location!.coordinate
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    // center this position
                    self.mapView.centerCoordinate = self.coordinates
                    
                    // zoom in the map to focus on the found coordinates
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.coordinates, 1000 * 2.0, 1000 * 2.0)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                    
                    // show the map and the components of the second part of screen
                    self.showSecondContainer()
                    
                } else {
                    self.showAlertWith("Failed to find location")
                }
            }
        }
    }
    
    // submit the location to the Parse service
    @IBAction func submit(sender: AnyObject) {
        
        loadingDialog.showLoading(view)
        
        // some values are setted to "" because for this we don't need them
        let studentDictionary = [
            ConnectionClient.ParseAPI.TagObjectId: "",
            ConnectionClient.ParseAPI.TagUniqueKey: ConnectionClient.UserLogin.accountKey!,
            ConnectionClient.ParseAPI.TagFirstName: ConnectionClient.UserLogin.userFirstName!,
            ConnectionClient.ParseAPI.TagLastName: ConnectionClient.UserLogin.userLastName!,
            ConnectionClient.ParseAPI.TagMapString: mapFindTextView.text,
            ConnectionClient.ParseAPI.TagMediaURL: addInfoTextView.text,
            ConnectionClient.ParseAPI.TagCreatedAt: "",
            ConnectionClient.ParseAPI.TagUpdatedAt: "",
            ConnectionClient.ParseAPI.TagLatitude: coordinates.latitude,
            ConnectionClient.ParseAPI.TagLongitude: coordinates.longitude
        ]
        
        let studentLocation = StudentLocation(dictionary: studentDictionary as! [String : AnyObject])
        
        ConnectionClient.sharedInstance().parsePostStudentLocation(studentLocation) { (result, error) in
            dispatch_async(dispatch_get_main_queue(), {
                    self.loadingDialog.dismissLoading()
            })
            
            if error != nil {
                self.showAlertWith(error!)
                
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.submitDone()
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    //MARK: Private functions
    
    private func showFirstContainer() {
        addInfoTextView.hidden = true
        mapView.hidden = true
        submitButton.hidden = true
        submitButtonBorder.hidden = true
        
        findOnTheMapButton.hidden = false
        mapFindTextView.hidden = false
        labelText.hidden = false
    }
    
    private func showSecondContainer() {
        addInfoTextView.hidden = false
        mapView.hidden = false
        submitButton.hidden = false
        submitButtonBorder.hidden = false
        
        view.backgroundColor = addInfoTextView.backgroundColor
        cancelButton.titleLabel?.textColor = UIColor.whiteColor()
        
        findOnTheMapButton.hidden = true
        mapFindTextView.hidden = true
        labelText.hidden = true
    }
    
    // show alert with custom message
    private func showAlertWith(message: String!) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}