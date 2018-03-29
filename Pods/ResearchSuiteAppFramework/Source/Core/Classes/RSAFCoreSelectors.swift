//
//  RSAFSelectors.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import ResearchSuiteResultsProcessor

public class RSAFCoreSelectors: NSObject {
    
    public static func isLoggedIn(_ state: RSAFCoreState) -> Bool {
        //coreState MUST be RSAFCoreState
        return state.loggedIn
    }
    
    public static func getExtensibleStorage(_ state: RSAFCoreState) -> [String : NSObject] {
        return state.extensibleStorage
    }
    
    public static func getValueInExtensibleStorage(_ state: RSAFCoreState) -> (String) -> NSSecureCoding? {
        return { key in
            return state.extensibleStorage[key] as? NSSecureCoding
        }
    }
    
    public static func getTaskBuilder(_ state: RSAFCoreState) -> RSTBTaskBuilder? {
        return state.taskBuilder
    }
    
    public static func getResultsProcessor(_ state: RSAFCoreState) -> RSRPResultsProcessor? {
        return state.resultsProcessor
    }
    
    public static func getTitleLabelText(_ state: RSAFCoreState) -> String? {
        return state.titleLabelText
    }
    
    public static func getTitleImage(_ state: RSAFCoreState) -> UIImage? {
        return state.titleImage
    }
    
//    public static func getResultsQueue(_ state: RSAFCoreState) -> [(UUID, RSAFActivityRun, ORKTaskResult)] {
//        return state.resultsQueue
//    }
    

}
