//
//  OMHIntermediateDatapointTransformer.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import ResearchSuiteResultsProcessor
import OMHClient

public protocol OMHIntermediateDatapointTransformer {
    static func transform(intermediateResult: RSRPIntermediateResult, additionalMetadata: [String: Any]?) -> OMHDataPointBuilder?
}
