//
//  LS2LoginStepGenerator.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//

import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class LS2LoginStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "LS2Login"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
            let managerProvider = helper.stateHelper as? LS2ManagerProvider else {
                return nil
        }
        
        let step = LS2LoginStep(
            identifier: customStepDescriptor.identifier,
            title: customStepDescriptor.title,
            text: customStepDescriptor.text,
            ls2Manager: managerProvider.getManager()
        )
        
        step.isOptional = false
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
