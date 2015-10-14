//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/9/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Components
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // loading dialog
    var loadingDialog = LoadingDialog()
    
    // textField delegate
    var textDelegate: CredentialsTextFieldDelegate!
    
    //MARK: Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDelegate = CredentialsTextFieldDelegate(screenView: view)
        
        usernameTextField.delegate = textDelegate
        passwordTextField.delegate = textDelegate
    }
    
    // MARK: Action functions
    
    // Do the login with the Udacity API
    @IBAction func loginAction(sender: AnyObject) {
        
        if( verifyFields() ) {
            loadingDialog.showLoading(view)
        
            ConnectionClient.sharedInstance().udacityLogin(usernameTextField.text, password: passwordTextField.text) { (result, error) in
                self.handleLoginResult(ConnectionClient.UdacityAPI.LoginUdacity, result: result, error: error)
            }
            
        } else {
            showAlertWith("All fields must be filled to log in!")
        }
    }
    
    // Do the login using the facebook API
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        loadingDialog.showLoading(view)
        
        // facebook access permission array
        let permissions = ["public_profile", "email"]
        
        ConnectionClient.sharedInstance().facebookManager.loginBehavior = FBSDKLoginBehavior.Web
        ConnectionClient.sharedInstance().facebookManager.logInWithReadPermissions(permissions, fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            
            guard error == nil else {
                self.showAlertWith("Failed to login with facebook!")
                return
            }
            // get the token
            if result.token != nil {

                ConnectionClient.sharedInstance().udacityLoginWithFacebook(result.token.tokenString) { (result, error) in
                    self.handleLoginResult(ConnectionClient.UdacityAPI.LoginFacebook, result: result, error: error)
                }
                
            } else {
                self.loadingDialog.dismissLoading()
            }
            
        }

    }
    
    // Go to the Udacity registration site
    @IBAction func signUpAction(sender: AnyObject) {
        let url = NSURL(string: ConnectionClient.UdacityAPI.RegistrationUrl)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    // MARK: Private functions
    
    // verify if all fields are filled to do the login
    private func verifyFields() -> Bool {
        return !(usernameTextField.text!.isEmpty) && !(passwordTextField.text!.isEmpty)
    }
    
    // MARK: Private functions
    
    // show alert with custom message
    private func showAlertWith(message: String!) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // handle the operation result
    private func handleLoginResult(type: Int!, result: AnyObject!, error: String!) {
        
        // dismiss the loading alert
        dispatch_async(dispatch_get_main_queue(), {
            self.loadingDialog.dismissLoading()
        })
        
        // handle the result
        if let status = result as? Bool where status {
            
            ConnectionClient.UserLogin.loginType = type
            dispatch_async(dispatch_get_main_queue(), {
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                
                // move to the next screen
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AppTabBarController") as! UITabBarController
                self.presentViewController(controller, animated: true, completion: nil)
            })
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.showAlertWith(error)
            })
        }
    }
}