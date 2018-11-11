//
//  RSEnhancedDayOfWeekChoiceStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/20/18.
//

import UIKit
import ResearchKit


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
open class RSEnhancedDayOfWeekChoiceStep: RSEnhancedMultipleChoiceStep {
    
    static public var choices: [ORKTextChoice] {
        
        let pairs = [
            ("Sunday".localized, NSNumber(integerLiteral: 1)),
            ("Monday".localized, NSNumber(integerLiteral: 2)),
            ("Tuesday".localized, NSNumber(integerLiteral: 3)),
            ("Wednesday".localized, NSNumber(integerLiteral: 4)),
            ("Thursday".localized, NSNumber(integerLiteral: 5)),
            ("Friday".localized, NSNumber(integerLiteral: 6)),
            ("Saturday".localized, NSNumber(integerLiteral: 7)),
        ]
        
        return pairs.map { pair in
            RSTextChoiceWithAuxiliaryAnswer(
                identifier: pair.0,
                text: pair.0,
                detailText: nil,
                value: pair.1,
                exclusive: false,
                auxiliaryItem: nil
            )
        }
    }
    
    public let minimumDays: Int
    public let maximumDays: Int
    public let consecutiveDaysAllowed: Bool
    
    public init(
        identifier: String,
        title: String?,
        text: String?,
        minimumDays: Int = 0,
        maximumDays: Int = 7,
        consecutiveDaysAllowed: Bool = true,
        cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type]
        )
    {
        
        self.minimumDays = minimumDays
        self.maximumDays = maximumDays
        self.consecutiveDaysAllowed = consecutiveDaysAllowed
        
        let answerFormat = ORKTextChoiceAnswerFormat(style: (maximumDays > 1) ? .multipleChoice : .singleChoice , textChoices: RSEnhancedDayOfWeekChoiceStep.choices)
        
        super.init(
            identifier: identifier,
            title: title,
            text: text,
            answer: answerFormat,
            cellControllerGenerators: cellControllerGenerators
        )
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSEnhancedDayOfWeekChoiceStepViewController.self
    }

}
