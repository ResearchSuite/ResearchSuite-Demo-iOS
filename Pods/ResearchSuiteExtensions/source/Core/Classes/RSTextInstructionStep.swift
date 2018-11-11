//
//  RSTextInstructionStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/18/18.
//

import UIKit

public struct RSTextInstructionStepSection {
    public let attributedText: NSAttributedString
    public let alignment: NSTextAlignment
}

open class RSTextInstructionStep: RSStep {
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSTextInstructionStepViewController.self
    }
    
    open var sections: [RSTextInstructionStepSection]?
    
}
