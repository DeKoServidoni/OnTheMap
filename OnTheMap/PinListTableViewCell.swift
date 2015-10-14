//
//  PinListTableViewCell.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

class PinListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentCoordinates: UILabel!
    @IBOutlet weak var studentLocal: UILabel!
    
    func setContentWith(firstName: String!, andLastName lastName: String!, andLocal local: String!, andLatitude latitude: Double!, andLongitude longitude: Double!) {
        studentName.text = firstName + " " + lastName
        studentLocal.text = local
        studentCoordinates.text = "Lat: \(latitude) Lon: \(longitude)"
    }
}