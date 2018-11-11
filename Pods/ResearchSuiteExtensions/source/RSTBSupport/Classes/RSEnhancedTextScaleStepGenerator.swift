//
//  RSEnhancedTextScaleStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedTextScaleStepGenerator: RSTBBaseStepGenerator, RSTBAnswerFormatGenerator {
    
    public func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public init(){}
    
    let _supportedTypes = [
        "enhancedTextScale"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateChoices(items: [RSTBChoiceItemDescriptor], helper: RSTBTaskBuilderHelper) -> [ORKTextChoice] {
        
        return items.map { item in
            
            return ORKTextChoice(
                text: helper.localizationHelper.localizedString(item.text),
                detailText: helper.localizationHelper.localizedString(item.detailText),
                value: item.value,
                exclusive: item.exclusive)
        }
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        guard let stepDescriptor = RSEnhancedTextScaleStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let choices = self.generateChoices(items: stepDescriptor.items, helper: helper)
        
        guard choices.count > 0 else {
            return nil
        }
        
        
        let answerFormat = RSEnhancedTextScaleAnswerFormat(
            textChoices: choices,
            defaultIndex: stepDescriptor.defaultIndex,
            vertical: stepDescriptor.vertical,
            maxValueLabel: helper.localizationHelper.localizedString(stepDescriptor.maximumValueLabel),
            minValueLabel: helper.localizationHelper.localizedString(stepDescriptor.minimumValueLabel),
            maximumValueDescription: helper.localizationHelper.localizedString(stepDescriptor.maximumValueDescription),
            neutralValueDescription: helper.localizationHelper.localizedString(stepDescriptor.neutralValueDescription),
            minimumValueDescription: helper.localizationHelper.localizedString(stepDescriptor.minimumValueDescription)
        )
        
        return answerFormat
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper) as? RSEnhancedTextScaleAnswerFormat,
            let stepDescriptor = RSEnhancedTextScaleStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedTextScaleStep(identifier: identifier, answerFormat: answerFormat)
        step.title = helper.localizationHelper.localizedString(stepDescriptor.title)
        step.text = helper.localizationHelper.localizedString(stepDescriptor.text)
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, helper: helper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, helper: helper)
        }
        
        step.isOptional = stepDescriptor.optional
        return [step]
        
    }

}
