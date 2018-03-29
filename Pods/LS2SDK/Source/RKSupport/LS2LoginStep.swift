//
//  LS2LoginStep.swift
//  Pods
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import ResearchSuiteExtensions

open class LS2LoginStep: RSLoginStep {
    
    public init(identifier: String,
                title: String? = nil,
                text: String? = nil,
                forgotPasswordButtonTitle: String? = nil,
                ls2Manager: LS2Manager? = nil) {
        
        let didLoad: (UIViewController) -> Void = { viewController in
            
            if let logInVC = viewController as? LS2LoginStepViewController {
                logInVC.ls2Manager = ls2Manager
            }
            
        }
        
        let title = title ?? "Log in"
        let text = text ?? "Please log in"
        
        super.init(identifier: identifier,
                   title: title,
                   text: text,
                   loginViewControllerClass: LS2LoginStepViewController.self,
                   loginViewControllerDidLoad: didLoad,
                   forgotPasswordButtonTitle: forgotPasswordButtonTitle)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
