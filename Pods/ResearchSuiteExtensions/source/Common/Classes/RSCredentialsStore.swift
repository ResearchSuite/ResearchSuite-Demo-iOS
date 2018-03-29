//
//  RSCredentialsStore.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/25/18.
//

import UIKit

public protocol RSCredentialsStore {
    func set(value: NSSecureCoding?, key: String)
    func get(key: String) -> NSSecureCoding?
}

open class RSKeychainCredentialsStore: NSObject, RSCredentialsStore {
    
    let namespace: String
    
    public init(namespace: String) {
        self.namespace = namespace
    }
    
    private func fullyQualifiedKey(key: String) -> String {
        return "\(self.namespace).\(key)"
    }
    
    open func set(value: NSSecureCoding?, key: String) {
        if let v = value {
            RSKeychainHelper.setKeychainObject(v, forKey: self.fullyQualifiedKey(key: key))
        }
        else {
            RSKeychainHelper.removeKeychainObject(forKey: self.fullyQualifiedKey(key: key))
        }
    }
    
    open func get(key: String) -> NSSecureCoding? {
        return RSKeychainHelper.getKeychainObject(self.fullyQualifiedKey(key: key))
    }
}
