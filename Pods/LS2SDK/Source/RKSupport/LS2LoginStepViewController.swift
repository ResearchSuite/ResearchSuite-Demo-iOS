//
//  LS2LoginStepViewController.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import ResearchSuiteExtensions

open class LS2LoginStepViewController: RSLoginStepViewController {

    open var ls2Manager: LS2Manager?
    
    open override func loginButtonAction(username: String, password: String, completion: @escaping ActionCompletion) {
        
        if let ls2Manager = self.ls2Manager {
            
            self.isLoading = true
            
            ls2Manager.signIn(username: username, password: password, forceSignIn: true) { (error) in
                
                self.isLoading = false
                
                debugPrint(error)
                if error == nil {
                    self.loggedIn = true
                    completion(true)
                }
                else {
                    self.loggedIn = false
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Log in failed", message: "Username / Password are not valid", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            (result : UIAlertAction) -> Void in
                            print("OK")
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        completion(false)
                    }
                    
                }
                
            }
        }
        
        
    }
    
    open override func forgotPasswordButtonAction(completion: @escaping ActionCompletion) {
        
        self.loggedIn = false
        completion(true)
        
    }

}
