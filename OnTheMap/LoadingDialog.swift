//
//  LoadingDialog.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/13/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

// Class responsible to hold a custom loading dialog
class LoadingDialog {
 
    // Activity indicator
    var actInd: UIActivityIndicatorView!
    var container: UIView!
    var loadingView: UIView!
    
    // show the loading dialog
    func showLoading(view: UIView!) {
        
        container = UIView()
        container.hidden = false
        container.frame = view.frame
        container.center = view.center
        
        loadingView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.center = view.center
        
        actInd = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        view.addSubview(container)
        
        actInd.startAnimating()
    }
    
    // dismiss the loading dialog
    func dismissLoading() {
        actInd.stopAnimating()
        actInd.hidden = true
        container.hidden = true
    }

}
