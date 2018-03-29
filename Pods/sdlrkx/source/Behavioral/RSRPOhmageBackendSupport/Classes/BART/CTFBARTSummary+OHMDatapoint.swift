//
//  CTFBARTSummary+OHMDatapoint.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import OMHClient

extension CTFBARTSummary: OMHDataPointBuilder {


    open var creationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var dataPointID: String {
        return self.uuid.uuidString
    }
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality {
        return .Sensed
    }
    
    public var acquisitionSourceCreationDateTime: Date {
        return self.startDate!
    }
    
    public var acquisitionSourceName: String {
        return (Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String)!
    }
    
    public var schema: OMHSchema {
        return OMHSchema(name: "BARTSummary", version: "1.1", namespace: "Cornell")
    }
    
    open var body: [String: Any] {
        return self.dataDictionary()
        
    }

}
