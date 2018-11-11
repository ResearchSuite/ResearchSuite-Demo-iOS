//
//  RSEnhancedDayOfWeekChoiceStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/20/18.
//

import UIKit
import ResearchKit

open class RSEnhancedDayOfWeekChoiceStepViewController: RSEnhancedMultipleChoiceStepViewController {
    
    func getAdjacentValues(value: Int, range: ClosedRange<Int>) -> (Int, Int) {
    
        let firstVal: Int = {
            let newVal = value - 1
            if !range.contains(newVal) {
                return range.upperBound
            }
            else {
                return newVal
            }
        }()
        
        let secondVal: Int = {
            let newVal = value + 1
            if !range.contains(newVal) {
                return range.lowerBound
            }
            else {
                return newVal
            }
        }()
        
        return (firstVal, secondVal)
    }
    
    open override func validate() -> Bool {
        
        guard let step = self.step as? RSEnhancedDayOfWeekChoiceStep else {
            return false
        }
        
        let selections = self.cellControllerMap.values.compactMap { (cellController) -> RSEnahncedMultipleChoiceSelection? in
            return cellController.choiceSelection
        }
        
        let selectedDays: [Int] = selections.compactMap { selection in
            if let number = selection.value as? NSNumber {
                return number.intValue
            }
            else {
                return nil
            }
        }
        
        if selectedDays.count < step.minimumDays ||
            selectedDays.count > step.maximumDays {
            return false
        }
        
        if !step.consecutiveDaysAllowed {
            
            let foundAdjacency = selectedDays.reduce(false) { (acc, day) -> Bool in
                
                if acc {
                    return acc
                }
                
                let (dayBefore, dayAfter) = self.getAdjacentValues(value: day, range: 1...7)
                
                return selectedDays.contains(dayBefore) || selectedDays.contains(dayAfter)
            }
            
            if foundAdjacency {
                return false
            }
            
        }
        
        return true
        
    }
    
    override open var result: ORKStepResult? {
        guard let result = super.result else {
            return nil
        }
        
        let selections = self.cellControllerMap.values.compactMap { (cellController) -> RSEnahncedMultipleChoiceSelection? in
            return cellController.choiceSelection
        }
        
        let selectedDays: [Int] = selections.compactMap { selection in
            if let number = selection.value as? NSNumber {
                return number.intValue
            }
            else {
                return nil
            }
        }
        
        let choiceResult = ORKChoiceQuestionResult(identifier: self.enhancedMultiChoiceStep.identifier)
        choiceResult.choiceAnswers = selectedDays
        
        result.results = [choiceResult]
        
        return result
    }

}
