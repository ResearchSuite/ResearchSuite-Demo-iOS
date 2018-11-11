//
//  RSQuestionTableViewStep.swift
//  Pods
//
//  Created by James Kizer on 4/6/17.
//
//

import UIKit
import ResearchKit

open class RSQuestionTableViewStep: RSStep {
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSQuestionTableViewController.self
    }

}
