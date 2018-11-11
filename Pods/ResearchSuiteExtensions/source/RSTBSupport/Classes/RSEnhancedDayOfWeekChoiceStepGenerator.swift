//
//  RSEnhancedDayOfWeekChoiceStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/20/18.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder
import ResearchKit

open class RSEnhancedDayOfWeekChoiceStepGenerator: RSTBBaseStepGenerator {
    
    //cell controller generators
    var cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type]
    
    public init(cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type] = [RSEnhancedMultipleChoiceBaseCellController.self]){
        self.cellControllerGenerators = cellControllerGenerators
    }
    
    let _supportedTypes = [
        "enhancedDayOfWeekChoice"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let stepDescriptor = RSEnhancedDayOfWeekChoiceStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedDayOfWeekChoiceStep(
            identifier: identifier,
            title: stepDescriptor.title,
            text: stepDescriptor.text,
            minimumDays: stepDescriptor.minimumDays,
            maximumDays: stepDescriptor.maximumDays,
            consecutiveDaysAllowed: stepDescriptor.consecutiveDaysAllowed,
            cellControllerGenerators: self.cellControllerGenerators
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
