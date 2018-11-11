//
//  RSTextInstructionStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/18/18.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSTextInstructionStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return ["textInstructionStep"]
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSTextInstructionStepDescriptor(json:jsonObject) else {
                return nil
        }
        
        let step = RSTextInstructionStep(identifier: stepDescriptor.identifier)
        step.title = helper.localizationHelper.localizedString(stepDescriptor.title)
        step.text = helper.localizationHelper.localizedString(stepDescriptor.text)
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, helper: helper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, helper: helper)
        }
        
        if let buttonText = stepDescriptor.buttonText {
            step.buttonText = helper.localizationHelper.localizedString(buttonText)
        }
        
        if let textSections = stepDescriptor.textSections {
            
            let sections: [RSTextInstructionStepSection] = textSections.compactMap { textSection in
                
                let attrStrOpt: NSAttributedString? = {
                    if let colorString = textSection.color,
                        let color = helper.stateHelper?.valueInState(forKey: colorString) as? UIColor {
                        return self.generateAttributedString(descriptor: textSection.templatedTextDescriptor, helper: helper, fontColor: color)
                    }
                    else {
                        return self.generateAttributedString(descriptor: textSection.templatedTextDescriptor, helper: helper)
                    }
                }()
                
                guard let attributedString = attrStrOpt else {
                    return nil
                }
                
                return RSTextInstructionStepSection(
                    attributedText: attributedString,
                    alignment: textSection.alignment
                )
                
            }
            
            step.sections = sections
        }
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
