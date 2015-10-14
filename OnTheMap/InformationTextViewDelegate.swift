//
//  InformationTextViewDelegate.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/13/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

class InformationTextViewDelegate: NSObject, UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}