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
import OMHClient
import sdlrkx


open class OMHTransformer: OMHIntermediateDatapointTransformer {
    public static func transform(intermediateResult: RSRPIntermediateResult, additionalMetadata: [String : Any]?) -> OMHDataPointBuilder? {
        
        if(intermediateResult.type == "PAMRaw"){
            guard let datapoint = intermediateResult as? CTFPAMRaw else {
                return nil
            }
            return DefaultRawOMHDatapoint(datapoint: datapoint)
        }
        if(intermediateResult.type == "YADLFullRaw"){
            guard let datapoint = intermediateResult as? YADLFullRaw else {
                return nil
            }
            return DefaultRawOMHDatapoint(datapoint: datapoint)
        }
        if(intermediateResult.type == "YADLSpotRaw"){
            guard let datapoint = intermediateResult as? YADLSpotRaw else {
                return nil
            }
            return DefaultRawOMHDatapoint(datapoint:datapoint)
        }
        if(intermediateResult.type == "DemographicsSurvey"){
            guard let datapoint = intermediateResult as? DemographicsSurveyResult else {
                return nil
            }
            return DefaultRawOMHDatapoint(datapoint:datapoint)
        }
        else {
            return nil
        }
        
    }


}

