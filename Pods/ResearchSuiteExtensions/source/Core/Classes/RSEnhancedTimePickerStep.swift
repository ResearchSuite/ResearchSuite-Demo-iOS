//
//  RSEnhancedTimePickerStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/19/18.
//

import UIKit

open class RSEnhancedTimePickerStep: RSStep {
    
    open override func stepViewControllerClass() -> AnyClass {
        return RSEnhancedTimePickerStepViewController.self
    }
    
    public let defaultComponents: DateComponents?
    public let minimumComponents: DateComponents?
    public let maximumComponents: DateComponents?
    
    public let minuteInterval: Int?
    
    public init(
        identifier: String,
        defaultComponents: DateComponents?,
        minimumComponents: DateComponents?,
        maximumComponents: DateComponents?,
        minuteInterval: Int?
                ) {
        self.defaultComponents = defaultComponents
        self.minimumComponents = minimumComponents
        self.maximumComponents = maximumComponents
        self.minuteInterval = minuteInterval
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
