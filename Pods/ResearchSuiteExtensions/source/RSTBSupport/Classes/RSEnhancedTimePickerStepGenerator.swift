//
//  RSEnhancedTimePickerStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/19/18.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder
import ResearchKit

open class RSEnhancedTimePickerStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "enhancedTimePicker"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let stepDescriptor = RSEnhancedTimePickerStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedTimePickerStep(
            identifier: identifier,
            defaultComponents: stepDescriptor.defaultComponents,
            minimumComponents: stepDescriptor.minimumComponents,
            maximumComponents: stepDescriptor.maximumComponents,
            minuteInterval: stepDescriptor.minuteInterval
        )
        
        step.title = helper.localizationHelper.localizedString(stepDescriptor.title)
        step.text = helper.localizationHelper.localizedString(stepDescriptor.text)
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, helper: helper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, helper: helper)
        }
        
        if let buttonText = stepDescriptor.buttonText {
            step.buttonText = buttonText
        }
        
        step.isOptional = stepDescriptor.optional
        return [step]
        
    }
    
    public func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
