//
//  LS2ParticipantAccountGeneratorRequestingCredentialsStepGenerator.swift
//  LS2SDK
//
//  Created by James Kizer on 8/2/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteExtensions
import ResearchKit


open class LS2ParticipantAccountGeneratorRequestingCredentialsStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "LS2ParticipantAccountGeneratorStepRequestingCredentials"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        
        guard let stepDescriptor = LS2ParticipantAccountGeneratorRequestingCredentialsStepDescriptor(json:jsonObject) else {
            return nil
        }
        
        let ls2ManagerKey = stepDescriptor.ls2ManagerKey ?? "ls2Manager"
        guard let stateHelper = helper.stateHelper,
            let manager = stateHelper.objectInState(forKey: ls2ManagerKey) as? LS2Manager else {
                return nil
        }
        
        //if generatorIDKey is supplied, it's a failure if there is nothing in the state
        if let generatorIDKey = stepDescriptor.generatorIDKey {
            guard let generatorID = stateHelper.objectInState(forKey: generatorIDKey) as? String else {
                return nil
            }
            
            let step = LS2ParticipantAccountGeneratorRequestingCredentialsStep(
                identifier: stepDescriptor.identifier,
                title: stepDescriptor.title,
                text: stepDescriptor.text,
                manager: manager,
                generatorID: generatorID,
                passwordFieldName: stepDescriptor.passwordFieldName
            )
            
            step.isOptional = false
            
            return step
            
        }
        else {
            
            let step = LS2ParticipantAccountGeneratorRequestingCredentialsStep(
                identifier: stepDescriptor.identifier,
                title: stepDescriptor.title,
                text: stepDescriptor.text,
                manager: manager,
                identityFieldName: stepDescriptor.identityFieldName,
                passwordFieldName: stepDescriptor.passwordFieldName
            )
            
            step.isOptional = false
            
            return step
            
        }
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    

}
