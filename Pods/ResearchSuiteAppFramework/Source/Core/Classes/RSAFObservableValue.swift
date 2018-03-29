//
//  RSAFObservableValue.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

public class RSAFObservableValue<T: Equatable>: NSObject {
    
    public typealias ObservationClosure = (T?) -> ()
    
    let _closure: ObservationClosure?
    var _value: T?
    
    public func get() -> T? {
        return _value
    }
    
    public func set(value: T?) {
        if value != _value {
            self._value = value
            self._closure?(value)
        }
    }
    
    public init(initialValue: T?, observationClosure: ObservationClosure?) {
        self._closure = observationClosure
        super.init()
        
        self._value = initialValue
        
    }

}
