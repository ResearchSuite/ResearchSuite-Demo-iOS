//
//  RSEnhancedDayOfWeekChoiceStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 10/20/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedDayOfWeekChoiceStepDescriptor: RSTBStepDescriptor {
    
    public let buttonText: String?
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    
    public let minimumDays: Int
    public let maximumDays: Int
    public let consecutiveDaysAllowed: Bool
    
    public required init?(json: JSON) {
        
        self.buttonText = "buttonText" <~~ json
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        
        self.minimumDays = "minimumDays" <~~ json ?? 0
        self.maximumDays = "maximumDays" <~~ json ?? 7
        self.consecutiveDaysAllowed = "consecutiveDaysAllowed" <~~ json ?? true
        
        super.init(json: json)
        
    }
    

}
