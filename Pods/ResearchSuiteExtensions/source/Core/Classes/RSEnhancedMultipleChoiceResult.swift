//
//  RSEnhancedMultipleChoiceResult.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import UIKit
import ResearchKit

public struct RSEnahncedMultipleChoiceSelection {
    public let value: NSCoding & NSCopying & NSObjectProtocol
    public let auxiliaryResult: ORKResult?
    
    public var description: String {
        return "\(value)"
    }
}

open class RSEnhancedMultipleChoiceResult: ORKResult {
    
    open var choiceAnswers: [RSEnahncedMultipleChoiceSelection]?
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let obj = super.copy(with: zone)
        if let choiceResult = obj as? RSEnhancedMultipleChoiceResult,
                let choiceAnswers = self.choiceAnswers {
            choiceResult.choiceAnswers = choiceAnswers
            return choiceResult
        }
        return obj
    }
    
    override open var description: String {
        //let answers: [String] = choiceAnswers!.map { $0.description }
        let answers: [String] = choiceAnswers != nil ? choiceAnswers!.map { $0.description } : [String]()
        
        if answers.count > 0 {
            var temp = super.description + "[" + answers.reduce("\n", { (acc, answer) -> String in
                return acc + answer + "\n"
            })
            return temp + "]"
        }
        else {
            return super.description + "[]"
        }
    }
    
}
