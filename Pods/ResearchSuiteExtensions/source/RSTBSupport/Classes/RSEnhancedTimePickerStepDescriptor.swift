//
//  RSEnhancedTimePickerStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/19/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchKit

open class RSEnhancedTimePickerStepDescriptor: RSTBTimePickerStepDescriptor {
    
    public let buttonText: String?
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    
    public let minuteInterval: Int?
    public let minimumComponents: DateComponents?
    public let maximumComponents: DateComponents?
    
    public required init?(json: JSON) {
        
        self.buttonText = "buttonText" <~~ json
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        
        self.minimumComponents = {
            guard let componentsString: String = "minimumComponents" <~~ json else {
                return nil
            }
            
            return ORKTimeOfDayComponentsFromString(componentsString)
        }()
        
        self.maximumComponents = {
            guard let componentsString: String = "maximumComponents" <~~ json else {
                return nil
            }
            
            return ORKTimeOfDayComponentsFromString(componentsString)
        }()
        
        self.minuteInterval = "minuteInterval" <~~ json
        
        super.init(json: json)
        
    }
    
}
