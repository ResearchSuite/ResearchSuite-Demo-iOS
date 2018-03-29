//
//  OMHDataPointBase.swift
//  Pods
//
//  Created by James Kizer on 1/7/17.
//
//

open class OMHDataPointBase: NSObject, OMHDataPointBuilder {
    
    open var dataPointID: String = UUID().uuidString
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality = .Sensed
    open var acquisitionSourceCreationDateTime: Date = Date()
    open var acquisitionSourceName: String = "unknown"
    
    open var schema: OMHSchema {
        fatalError("Not Implemented")
    }
    
    open var body: [String: Any] {
        fatalError("Not Implemented")
    }
    
    open var metadata: [String : Any]?

    public required override init() {
        
    }
    
    public init(dataPointID: String,
                acquisitionModality: OMHAcquisitionProvenanceModality,
                acquisitionSourceCreationDateTime: Date,
                acquisitionSourceName: String
            ) {
        self.dataPointID = dataPointID
        self.acquisitionModality = acquisitionModality
        self.acquisitionSourceCreationDateTime = acquisitionSourceCreationDateTime
        self.acquisitionSourceName = acquisitionSourceName
        
        super.init()
    }
    
}
