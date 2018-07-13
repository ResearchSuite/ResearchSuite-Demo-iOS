//
//  File.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 3/27/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import Foundation
import LS2SDK
import ResearchSuiteResultsProcessor
//import OMHClient
import sdlrkx
import Gloss


extension CTFPAMRaw: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        guard let schema: LS2Schema = LS2Schema(name: "photographic-affect-meter-scores", version: LS2SchemaVersion(major: 1, minor: 0, patch: 0), namespace: "Cornell") else {
            return nil
        }
        
        let body: JSON = {
            var body: JSON = self.pamChoice
            body["effective_time_frame"] = Gloss.Encoder.encode(dateISO8601ForKey: "date_time")(creationDate)
            return body
        }()
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}

//open class OMHTransformer: OMHIntermediateDatapointTransformer {
//    public static func transform(intermediateResult: RSRPIntermediateResult, additionalMetadata: [String : Any]?) -> OMHDataPointBuilder? {
//
//        if(intermediateResult.type == "PAMRaw"){
//            guard let datapoint = intermediateResult as? CTFPAMRaw else {
//                return nil
//            }
//            return DefaultRawOMHDatapoint(datapoint: datapoint)
//        }
//        if(intermediateResult.type == "YADLFullRaw"){
//            guard let datapoint = intermediateResult as? YADLFullRaw else {
//                return nil
//            }
//            return DefaultRawOMHDatapoint(datapoint: datapoint)
//        }
//        if(intermediateResult.type == "YADLSpotRaw"){
//            guard let datapoint = intermediateResult as? YADLSpotRaw else {
//                return nil
//            }
//            return DefaultRawOMHDatapoint(datapoint:datapoint)
//        }
//        if(intermediateResult.type == "DemographicsSurvey"){
//            guard let datapoint = intermediateResult as? DemographicsSurveyResult else {
//                return nil
//            }
//            return DefaultRawOMHDatapoint(datapoint:datapoint)
//        }
//        else {
//            return nil
//        }
//
//    }
//
//
//}

