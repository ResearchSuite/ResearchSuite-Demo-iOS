//
//  LS2Client.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import Alamofire
import OMHClient

open class LS2Client: NSObject {
    
    public struct SignInResponse {
        public let authToken: String
    }
    
    let baseURL: String
    let dispatchQueue: DispatchQueue?
    let sessionManager: SessionManager
    
    public init(baseURL: String, dispatchQueue: DispatchQueue? = nil, serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        self.baseURL = baseURL
        self.dispatchQueue = dispatchQueue
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        self.sessionManager = SessionManager(configuration: configuration, serverTrustPolicyManager: serverTrustPolicyManager)
        
        super.init()
    }
    
    open func processAuthResponse(isRefresh: Bool, completion: @escaping ((SignInResponse?, Error?) -> ())) -> ((DataResponse<Any>) -> ()) {
        
        return { jsonResponse in
            
            debugPrint(jsonResponse)
            //check for lower level errors
            if let error = jsonResponse.result.error as? NSError {
                if error.code == NSURLErrorNotConnectedToInternet {
                    completion(nil, LS2ClientError.unreachableError(underlyingError: error))
                    return
                }
                else {
                    completion(nil, LS2ClientError.otherError(underlyingError: error))
                    return
                }
            }
            
            //check for our errors
            //credentialsFailure
            guard let response = jsonResponse.response else {
                completion(nil, LS2ClientError.malformedResponse(responseBody: jsonResponse))
                return
            }
            
            if let response = jsonResponse.response,
                response.statusCode == 502 {
                debugPrint(jsonResponse)
                completion(nil, LS2ClientError.badGatewayError)
                return
            }

            //check for malformed body
            guard jsonResponse.result.isSuccess,
                let json = jsonResponse.result.value as? [String: Any],
                let authToken = json["token"] as? String else {
                    completion(nil, LS2ClientError.malformedResponse(responseBody: jsonResponse.result.value))
                    return
            }
            
            let signInResponse = SignInResponse(authToken: authToken)
            completion(signInResponse, nil)
            
        }
        
    }
    
    open func signIn(username: String, password: String, completion: @escaping ((SignInResponse?, Error?) -> ())) {
        
        let urlString = "\(self.baseURL)/auth/token"
        let parameters = [
            "username": username,
            "password": password
        ]
        
        let request = self.sessionManager.request(
            urlString,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: self.processAuthResponse(isRefresh: false, completion: completion))
        
    }
    
    //nil Bool value here means the validity check is inconclusive
    open func checkTokenIsValid(token: String, completion: @escaping ((Bool?, Error?) -> ())) {
        let urlString = "\(self.baseURL)/auth/token/check"
        let headers = ["Authorization": "Token \(token)", "Accept": "application/json"]
        
        let request = self.sessionManager.request(
            urlString,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: self.processTokenValidationResponse(completion: completion))
    }
    
    private func processTokenValidationResponse(completion: @escaping ((Bool?, Error?) -> ())) -> (DataResponse<Any>) -> () {
        
        return { jsonResponse in
            //check for actually success
            
            debugPrint(jsonResponse)
            
            switch jsonResponse.result {
            case .success:
                print("Validation Successful")
                guard let response = jsonResponse.response else {
                    completion(false, LS2ClientError.unknownError)
                    return
                }
                
                switch (response.statusCode) {
                case 200:
                    completion(true, nil)
                    return
                    
                case 401:
                    completion(false, LS2ClientError.invalidAuthToken)
                    return
                    
                case 500:
                    completion(nil, LS2ClientError.serverError)
                    return
                    
                case 502:
                    completion(nil, LS2ClientError.badGatewayError)
                    return
                    
                default:
                    
                    if let error = jsonResponse.result.error {
                        completion(nil, error)
                        return
                    }
                    else {
                        completion(nil, LS2ClientError.malformedResponse(responseBody: jsonResponse))
                        return
                    }
                    
                }
                
                
            case .failure(let error):
                let nsError = error as NSError
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    completion(nil, LS2ClientError.unreachableError(underlyingError: nsError))
                    return
                }
                else {
                    completion(nil, LS2ClientError.otherError(underlyingError: nsError))
                    return
                }
            }
        }
        
        
    }
    
    
    
    open func validateSample(sample: OMHDataPoint) -> Bool {
        
        let sampleDict = sample.toDict()
        NSLog("sample Dict test")
        NSLog(String(describing: sampleDict))
        return JSONSerialization.isValidJSONObject(sampleDict)
        
    }
    
    open func postSample(
        sampleDict: OMHDataPointDictionary,
        token: String,
        completion: @escaping ((Bool, Error?) -> ())) {
        
        self.postJSONSample(sampleDict: sampleDict, token: token, completion: completion)
        
    }
    
    public func signOut(token: String, completion: @escaping ((Bool, Error?) -> ())) {
        let urlString = "\(self.baseURL)/auth/logout"
        let headers = ["Authorization": "Token \(token)", "Accept": "application/json"]
        
        let request = self.sessionManager.request(
            urlString,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers)
        
        let reponseProcessor: (DataResponse<Any>) -> () = self.processLogoutResponse(completion: completion)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: reponseProcessor)
        
    }
    
    private func processLogoutResponse(completion: @escaping ((Bool, Error?) -> ())) -> (DataResponse<Any>) -> () {
        
        return { jsonResponse in
            //check for actually success
            
            debugPrint(jsonResponse)
            //check for lower level errors
            if let error = jsonResponse.result.error as NSError? {
                if error.code == NSURLErrorNotConnectedToInternet {
                    completion(false, LS2ClientError.unreachableError(underlyingError: error))
                    return
                }
                else {
                    completion(false, LS2ClientError.otherError(underlyingError: error))
                    return
                }
            }
            
            //check for our errors
            //credentialsFailure
            guard let _ = jsonResponse.response else {
                completion(false, LS2ClientError.malformedResponse(responseBody: jsonResponse))
                return
            }
            
            if let response = jsonResponse.response,
                response.statusCode == 502 {
                debugPrint(jsonResponse)
                completion(false, LS2ClientError.badGatewayError)
                return
            }
            
            //check for malformed body
            guard jsonResponse.result.isSuccess,
                let response = jsonResponse.response,
                response.statusCode == 200 else {
                    completion(false, LS2ClientError.malformedResponse(responseBody: jsonResponse.result.value))
                    return
            }
            
            completion(true, nil)
        }
        
        
    }

    private func postJSONSample(sampleDict: OMHDataPointDictionary, token: String, completion: @escaping ((Bool, Error?) -> ())) {
        let urlString = "\(self.baseURL)/dataPoints"
        let headers = ["Authorization": "Token \(token)", "Accept": "application/json"]
        let params = sampleDict
        
        guard JSONSerialization.isValidJSONObject(sampleDict) else {
            completion(false, LS2ClientError.invalidDatapoint)
            return
        }
        
        let request = self.sessionManager.request(
            urlString,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers)
        
        let reponseProcessor: (DataResponse<Any>) -> () = self.processDatapointUploadResponse(completion: completion)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: reponseProcessor)
        
    }
    
    private func processDatapointUploadResponse(completion: @escaping ((Bool, Error?) -> ())) -> (DataResponse<Any>) -> () {
        
        return { jsonResponse in
            //check for actually success
            
            debugPrint(jsonResponse)
            
            switch jsonResponse.result {
            case .success:
                print("Validation Successful")
                guard let response = jsonResponse.response else {
                    completion(false, LS2ClientError.unknownError)
                    return
                }
                
                switch (response.statusCode) {
                case 201:
                    completion(true, nil)
                    return
                    
                case 400:
                    completion(false, LS2ClientError.invalidDatapoint)
                    return
                    
                case 401:
                    completion(false, LS2ClientError.invalidAuthToken)
                    return
                
                case 409:
                    completion(false, LS2ClientError.dataPointConflict)
                    return
                    
                case 500:
                    completion(false, LS2ClientError.serverError)
                    return
                    
                case 502:
                    completion(false, LS2ClientError.badGatewayError)
                    return

                default:
                    
                    if let error = jsonResponse.result.error {
                        completion(false, error)
                        return
                    }
                    else {
                        completion(false, LS2ClientError.malformedResponse(responseBody: jsonResponse))
                        return
                    }
                    
                }
                
                
            case .failure(let error):
                let nsError = error as NSError
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    completion(false, LS2ClientError.unreachableError(underlyingError: nsError))
                    return
                }
                else {
                    completion(false, LS2ClientError.otherError(underlyingError: nsError))
                    return
                }
            }
        }
        
    }
    
    

}
