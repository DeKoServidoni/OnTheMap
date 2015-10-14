//
//  MapViewController.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/10/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate, InformationPostingProtocol {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Annotations array
    var annotations = [MKPointAnnotation]()
    
    //MARK: Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudentLocations()
    }
    
    //MARK: Actions
    
    @IBAction func refreshList(sender: AnyObject) {
        mapView.removeAnnotations(annotations)
        StudentManager.sharedInstance().clean()
        getStudentLocations()
    }
    
    @IBAction func addLocationPin(sender: AnyObject) {
        presentPostingView(self)
    }
    
    //MARK: Private functions
    
    // load student location list
    private func getStudentLocations() {
        
        ConnectionClient.sharedInstance().parseGetStudentLocations() { (result, error) in
            
            if error != nil  {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showAlertWith(error)
                }
                
            } else {
                
                let array = StudentManager.sharedInstance().studentArray
                
                // clean the annotations array
                self.annotations.removeAll()
                
                for student in array {

                    // This is a version of the Double type.
                    let lat = CLLocationDegrees((student.latitude)!)
                    let long = CLLocationDegrees((student.longitude)!)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(student.firstName!) \(student.lastName!)"
                    annotation.subtitle = student.mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    self.annotations.append(annotation)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(self.annotations)
                }
            }
        }
    }
    
    //MARK: Post delegate
    
    func submitDone() {
        refreshList("")
    }
    
    //MARK: Map delegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("MapPin") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapPin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor =  UIColor.orangeColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let toOpen = view.annotation?.subtitle! {
            UIApplication.sharedApplication().openURL(NSURL(string: toOpen)!)
        }
    }
}