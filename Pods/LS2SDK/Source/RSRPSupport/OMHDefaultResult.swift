//
//  OMHDefaultResult.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import ResearchSuiteResultsProcessor
import OMHClient
import Alamofire

open class OMHDefaultResult: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    private static let supportedTypes = [
        "defaultResult"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    public static var defaultAcquisitionSourceName: String {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                let osName: String = {
                    #if os(iOS)
                        return "iOS"
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        return "OS X"
                    #elseif os(Linux)
                        return "Linux"
                    #else
                        return "Unknown"
                    #endif
                }()
                
                return "\(osName) \(versionString)"
            }()
            
            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
        }
        else {
            return "Unknown"
        }
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
        
        guard let resultDict = RSRPDefaultResultHelpers.extractResults(parameters: parameters, forSerialization: true) else {
            return nil
        }
        
        let defaultResult = OMHDefaultResult(
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
            type: "OMHDefaultResult",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}

extension OMHDefaultResult: OMHDataPointBuilder {

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
