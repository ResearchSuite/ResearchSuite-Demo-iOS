//
//  RSEnhancedMultipleChoiceStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import Gloss
import ResearchSuiteTaskBuilder


open class RSEnhancedMultipleChoiceStepDescriptor: RSTBChoiceStepDescriptor<RSEnhancedChoiceItemDescriptor> {

    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    
    required public init?(json: JSON) {
        
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        
        super.init(json: json)
    }
    
}

