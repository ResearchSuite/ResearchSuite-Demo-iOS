//
//  LS2ParticipantAccountGeneratorRequestingCredentialsStepDescriptor.swift
//  LS2SDK
//
//  Created by James Kizer on 8/2/18.
//

import UIKit
import ResearchSuiteExtensions
import Gloss
import ResearchSuiteTaskBuilder

open class LS2ParticipantAccountGeneratorRequestingCredentialsStepDescriptor: LS2ParticipantAccountGeneratorStepDescriptor {
    
    public let ls2ManagerKey: String?
    public let generatorIDKey: String?
    public let identityFieldName: String?
    public let passwordFieldName: String?
    
    required public init?(json: JSON) {
        
        self.ls2ManagerKey = "ls2ManagerKey" <~~ json
        self.generatorIDKey = "generatorIDKey" <~~ json
        self.identityFieldName = "identityFieldName" <~~ json
        self.passwordFieldName = "passwordFieldName" <~~ json
        
        super.init(json: json)
    }
    

}
