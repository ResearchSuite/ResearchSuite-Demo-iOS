//
//  RSRedirectStep.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit
import ResearchKit

open class RSRedirectStep: RSStep {
    
    let delegate: RSRedirectStepDelegate
    
    public init(identifier: String,
                title: String? = nil,
                text: String? = nil,
                buttonText: String? = nil,
                delegate: RSRedirectStepDelegate) {
        
        let title = title ?? "Log in"
        let text = text ?? "Please log in"
        self.delegate = delegate
        
        super.init(identifier: identifier)
        
        self.title = title
        self.text = text
        self.buttonText = buttonText ?? "Log In"
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSRedirectStepViewController.self
    }
}
