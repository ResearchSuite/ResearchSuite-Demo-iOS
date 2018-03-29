//
//  OMHDataPointBuilder.swift
//  Pods
//
//  Created by James Kizer on 1/13/17.
//
//

public class OMHSchema {
    let name: String
    let version: String
    let namespace: String
    
    public init(name: String, version: String, namespace: String) {
        self.name = name
        self.version = version
        self.namespace = namespace
    }
}

public enum OMHAcquisitionProvenanceModality: String {
    case Sensed = "sensed"
    case SelfReported = "self-reported"
}

public class OMHAcquisitionProvenance {
    let sourceName: String
    let sourceCreationDateTime: Date
    let modality: OMHAcquisitionProvenanceModality
    public init(sourceName: String, sourceCreationDateTime: Date, modality: OMHAcquisitionProvenanceModality) {
        self.sourceName = sourceName
        self.sourceCreationDateTime = sourceCreationDateTime
        self.modality = modality
    }
    
    public func toDict() -> [String: String]?  {
        return [
            "source_name": self.sourceName,
            "source_creation_date_time": staticISO8601Formatter.string(from: self.sourceCreationDateTime),
            "modality": self.modality.rawValue
        ]
    }
    
}

public protocol OMHDataPointBuilder: OMHDataPoint {
    var dataPointID: String { get }
    var schema: OMHSchema { get }
    
    //header
    var header: [String: Any] { get }
    
    var acquisitionSourceName: String { get }
    var acquisitionSourceCreationDateTime: Date { get }
    var acquisitionModality: OMHAcquisitionProvenanceModality { get }
    var acquisitionProvenance: OMHAcquisitionProvenance { get }
    
    var metadata: [String: Any]? { get }
    
    var body: [String: Any] { get }
}

public extension OMHDataPointBuilder {
    
    public func toDict() -> OMHDataPointDictionary {
        return [
            "header": self.header,
            "body": self.body
        ]
    }
    
    public var schemaDict: [String: String] {
        return [
            "namespace": self.schema.namespace,
            "name": self.schema.name,
            "version": self.schema.version
        ]
    }
    
    public var header: [String: Any] {
        
        var header: [String: Any] = [
            "id": self.dataPointID,
            "schema_id": self.schemaDict,
            "acquisition_provenance": self.acquisitionProvenance.toDict(),
            ]
        
        if let metadata = self.metadata {
            header["metadata"] = metadata
        }
        
        return header
    }
    
    public var acquisitionProvenance: OMHAcquisitionProvenance {
        return OMHAcquisitionProvenance(
            sourceName: self.acquisitionSourceName,
            sourceCreationDateTime: self.acquisitionSourceCreationDateTime,
            modality: self.acquisitionModality
        )
    }
    
    public var metadata: [String: Any]? {
        return nil
    }
}
