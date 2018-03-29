//
//  OMHDefaultTransformer.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import OMHClient
import ResearchSuiteResultsProcessor

open class OMHDefaultTransformer: OMHIntermediateDatapointTransformer {
    
    public static func transform(intermediateResult: RSRPIntermediateResult, additionalMetadata: [String : Any]?) -> OMHDataPointBuilder? {
        guard let datapoint = intermediateResult as? OMHDataPointBuilder else {
            return nil
        }
        
        return OMHDataPointWithMetadataProxy(datapoint: datapoint, additionalMetadata: additionalMetadata)
    }
    
}
