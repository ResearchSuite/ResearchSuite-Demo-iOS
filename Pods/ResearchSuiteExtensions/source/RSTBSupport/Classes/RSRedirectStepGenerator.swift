//
//  RSRedirectStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class RSRedirectStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return nil
    }
    
    open func getDelegate(helper: RSTBTaskBuilderHelper) -> RSRedirectStepDelegate? {
        return nil
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSRedirectStepDescriptor(json:jsonObject),
            let delegate = self.getDelegate(helper: helper) else {
                return nil
        }
        
        let buttonText: String = helper.localizationHelper.localizedString(stepDescriptor.buttonText)
        
        let step = RSRedirectStep(
            identifier: stepDescriptor.identifier,
            title: helper.localizationHelper.localizedString(stepDescriptor.title),
            text: helper.localizationHelper.localizedString(stepDescriptor.text),
            buttonText: buttonText,
            delegate: delegate
        )
        
        step.isOptional = stepDescriptor.optional
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
