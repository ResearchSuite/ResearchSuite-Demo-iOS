//
//  RSLoginStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import ResearchKit

open class RSLoginStepViewController: ORKFormStepViewController {
    
    public typealias ActionCompletion = (Bool) -> ()
    
    public static let LoggedInResultIdentifier = "IsLoggedInResult"
    public var loggedIn: Bool?
    open var activityIndicator: UIActivityIndicatorView?
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        self.activityIndicator = activityIndicator
        
        if let step = self.step as? RSLoginStep {
            self.continueButtonTitle = step.loginButtonTitle
            self.skipButtonTitle = step.forgotPasswordButtonTitle
            
            step.loginViewControllerDidLoad?(self)
        }
        
    }
    
    open var isLoading: Bool = false {
        didSet {
            if isLoading != oldValue {
                let localIsLoading = isLoading
                DispatchQueue.main.async {
                    if localIsLoading {
                        self.activityIndicator?.startAnimating()
                        self.view.isUserInteractionEnabled = false
                        
                    }
                    else {
                        self.activityIndicator?.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    override open var result: ORKStepResult? {
        if let parent = super.result {
            
            if let loggedIn = loggedIn {
                
                let loggedInResult = ORKBooleanQuestionResult(identifier: RSLoginStepViewController.LoggedInResultIdentifier)
                loggedInResult.booleanAnswer = NSNumber.init(booleanLiteral: loggedIn)
                
                parent.results?.append(loggedInResult)
            }
            
            return parent
        }
        else {
            return nil
        }
    }
    
    
    override open func goForward() {
        
        guard let loginStep = self.step as? RSLoginStep,
            let loginStepResult = self.result else {
                return
        }
        
        self.handleButtonTap(
            identityResult: loginStepResult.result(forIdentifier: RSLoginStep.RSLoginStepIdentity),
            passwordResult: loginStepResult.result(forIdentifier: RSLoginStep.RSLoginStepPassword)
        ) { moveForward in
            if moveForward {
                DispatchQueue.main.async {
                    super.goForward()
                }
            }
        }
        
    }
    
    open func handleButtonTap(identityResult: ORKResult?, passwordResult: ORKResult?, completion: @escaping ActionCompletion) {
        
        let username = (identityResult as? ORKTextQuestionResult)?.answer as? String
        let password = (passwordResult as? ORKTextQuestionResult)?.answer as? String
        
        switch (username, password) {
            
        case (.some(let username), .some(let password)):
            self.loginButtonAction(username: username, password: password, completion: completion)
            
        default:
            self.forgotPasswordButtonAction(completion: completion)
        }
        
    }
    
    
    open func loginButtonAction(username: String, password: String, completion: @escaping ActionCompletion) {
        completion(true)
    }
    
    open func forgotPasswordButtonAction(completion: @escaping ActionCompletion) {
        completion(true)
    }
}
