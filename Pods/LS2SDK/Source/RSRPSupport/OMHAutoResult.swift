//
//  OMHAutoResult.swift
//  LS2SDK
//
//  Created by James Kizer on 1/17/18.
//

import UIKit
import OMHClient
import ResearchSuiteResultsProcessor
import ResearchKit

open class OMHAutoResult: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    private static let supportedTypes = [
        "auto"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    
    
    public class func extractResults(parameters: [String : AnyObject], forSerialization: Bool) -> [String: AnyObject]? {
        
        
        //look for arrays of step results
        
        let selector: (RSRPDefaultValueTransformer) -> AnyObject? = {
            if forSerialization { return { $0.defaultSerializedValue } }
            else { return { $0.defaultValue } }
        }()
        
        var resultsMap: [String: AnyObject] = [:]
        
        parameters.forEach { (key,value) in
            
            guard let stepResultArray = value as? [ORKStepResult] else {
                return
            }
            
            stepResultArray.forEach { stepResult in
                
                guard let resultArray =  stepResult.results else {
                    return
                }
                
                resultArray.forEach({ (result) in
                    
                    //get identifier
                    let identifierComponentArray = result.identifier.components(separatedBy: ".")
                    assert(identifierComponentArray.count > 0)
                    
                    let identifier: String = identifierComponentArray.last!
                    if  let transformable = result as? RSRPDefaultValueTransformer {
                        if let resultValue: AnyObject = selector(transformable) {
                            assert(resultsMap[identifier] == nil, "Duplicate values for key \(identifier)")
                            resultsMap[identifier] = resultValue
                        }
                    }
                    else {
                        assertionFailure("value for \(identifier) is not transformable")
                    }
                    
                })

            }
            
        }
        
        return resultsMap
        
    }
    
    public class func transform(taskIdentifier: String, taskRunUUID: UUID, parameters: [String : AnyObject]) -> RSRPIntermediateResult? {
        
        //extract schema info
        guard let schemaDict = parameters["schema"] as? [String: String],
            let schemaNamespace = schemaDict["namespace"],
            let schemaName = schemaDict["name"],
            let schemaVersion = schemaDict["version"] else {
                return nil
        }
        
        let schema = OMHSchema(name: schemaName, version: schemaVersion, namespace: schemaNamespace)
        
        guard let resultDict = OMHAutoResult.extractResults(parameters: parameters, forSerialization: true) else {
            return nil
        }
        
        let defaultResult = OMHAutoResult(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schema: schema,
            resultDict: resultDict)
        
        defaultResult.startDate = RSRPDefaultResultHelpers.startDate(parameters: parameters)
        defaultResult.endDate = RSRPDefaultResultHelpers.endDate(parameters: parameters)
        
        return defaultResult
        
    }
    
    public let schema: OMHSchema
    public let resultDict: [String: AnyObject]
    
    public init(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        schema: OMHSchema,
        resultDict: [String: AnyObject]
        ) {
        
        self.schema = schema
        self.resultDict = resultDict
        
        super.init(
            type: "OMHAutoResult",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}

extension OMHAutoResult: OMHDataPointBuilder {
    
    open var dataPointID: String {
        return self.uuid.uuidString
    }
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality {
        return .SelfReported
    }
    
    open var acquisitionSourceCreationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var acquisitionSourceName: String {
        return OMHDefaultResult.defaultAcquisitionSourceName
    }
    
    open var body: [String: Any] {
        return self.resultDict
    }
    
}
