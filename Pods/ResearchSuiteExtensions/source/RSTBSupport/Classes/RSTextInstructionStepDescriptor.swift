//
//  RSTextInstructionStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/18/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

public struct RSTextInstructionStepSectionDescriptor: Gloss.JSONDecodable {
    
    public let templatedTextDescriptor: RSTemplatedTextDescriptor
    public let color: String?
    public let alignment: NSTextAlignment
    
    
    
    public init?(json: JSON) {
        
        guard let templatedTextDescriptor: RSTemplatedTextDescriptor = RSTemplatedTextDescriptor(json: json) else {
            return nil
        }
        
        self.alignment = {
            if let alignment: String = "alignment" <~~ json {
                switch alignment {
                case "left":
                    return .left
                case "right":
                    return .right
                case "center":
                    return .center
                case "justified":
                    return .justified
                default:
                    return .natural
                }
            }
            else {
                return .natural
            }
        }()
        
        self.templatedTextDescriptor = templatedTextDescriptor
        self.color = "color" <~~ json
        
    }
    
}
open class RSTextInstructionStepDescriptor: RSTBStepDescriptor {
    
    public let buttonText: String?
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    public let textSections: [RSTextInstructionStepSectionDescriptor]?
    
    required public init?(json: JSON) {
        
        self.buttonText = "buttonText" <~~ json
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        
        self.textSections = {
            if let textSectionsJSON: [JSON] = "sections" <~~ json {
                return textSectionsJSON.compactMap { RSTextInstructionStepSectionDescriptor(json: $0) }
            }
            else {
                return nil
            }
        }()
        
        super.init(json: json)
    }

}
