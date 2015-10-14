//
//  CredentialsTextFieldDelegate.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/13/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

class CredentialsTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    let container: UIView!
    
    init(screenView: UIView!) {
        container = screenView
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        subscribeToKeyboardNotification()
    }
    
    // dismiss the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        unsubscribeFromKeyboardNotification()
        return true
    }
    
    //MARK: keyboard layout functions
    
    // change the size of the view to move up when the keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        container.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    // change the size of the view to move up when the keyboard disappears
    func keyboardWillDismiss(notification: NSNotification) {
        container.frame.origin.y = 0
    }
    
    // get the keyboard hight from the notification
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: notification functions
    
    // add a observer to the notification center so we can discover when the keyboard showed up
    private func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDismiss:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // remove the observer from the notification center
    private func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}