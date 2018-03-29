//
//  OMHDatapointWithMetadataProxy.swift
//  LS2SDK
//
//  Created by James Kizer on 3/21/18.
//

import UIKit
import OMHClient

open class OMHDataPointWithMetadataProxy: OMHDataPointBuilder {
    
    public var dataPointID: String {
        return self.datapoint.dataPointID
    }
    
    public var schema: OMHSchema {
        return self.datapoint.schema
    }
    
    public var acquisitionSourceName: String {
        return self.datapoint.acquisitionSourceName
    }
    
    public var acquisitionSourceCreationDateTime: Date {
        return self.datapoint.acquisitionSourceCreationDateTime
    }
    
    public var acquisitionModality: OMHAcquisitionProvenanceModality {
        return self.datapoint.acquisitionModality
    }
    
    public var body: [String : Any] {
        return self.datapoint.body
    }
    
    public var metadata: [String: Any]? {
        
        //get datapoint's metadata
        //merge in additional metadata
        if let existingMetadata = self.datapoint.metadata,
            let additionalMetadata = self.additionalMetadata {
            return existingMetadata.merging(additionalMetadata) { (_, new) in new }
        }
        else if let existingMetadata = self.datapoint.metadata {
            return existingMetadata
        }
        else {
            return self.additionalMetadata
        }
        
    }
    
    let datapoint: OMHDataPointBuilder
    let additionalMetadata: [String: Any]?
    
    public init(datapoint: OMHDataPointBuilder, additionalMetadata: [String: Any]? = nil) {
        self.datapoint = datapoint
        self.additionalMetadata = additionalMetadata
    }
    

}
