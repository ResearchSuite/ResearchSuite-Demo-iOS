//
//  AppDelegate.swift
//  YADL-Reference-App
//
//  Created by Christina Tsangouri on 11/6/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchSuiteResultsProcessor
import Gloss
import sdlrkx
import UserNotifications
import LS2SDK
import ResearchSuiteExtensions
import ResearchSuiteAppFramework


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var store: RSStore!
    var taskBuilder: RSTBTaskBuilder!
    var resultsProcessor: RSRPResultsProcessor!
//    var CSVBackend: RSRPCSVBackEnd!
    var ls2Manager: LS2Manager!
    var ls2Backend: LS2BackEnd!
    
//    var store: RSCredentialsStore!
    
    
    @available(iOS 10.0, *)
    var center: UNUserNotificationCenter!{
        return UNUserNotificationCenter.current()
    }
    
    func initializeLS2(credentialStore: RSCredentialsStore, config: String, logger: RSLogger?) -> LS2Manager {
        guard let file = Bundle.main.path(forResource: "LS2Client", ofType: "plist") else {
            fatalError("Could not initialze LS2Manager")
        }
        
        
        let clientDetails = NSDictionary(contentsOfFile: file)
        
        guard let configDict = clientDetails?[config] as? [String: String],
            let baseURL = configDict["baseURL"] else {
                fatalError("Could not initialze LS2Manager")
        }
        
        let manager: LS2Manager? = {
            return LS2Manager(
                baseURL: baseURL,
                queueStorageDirectory: "ls2SDKCache",
                store: credentialStore,
                logger: logger
            )
        }()
        
        if let m = manager {
            return m
        }
        else {
            fatalError("Could not initialze LS2 Manager")
        }
    }
    


    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        self.store.setValueInState(value: true as NSSecureCoding, forKey: "shouldDoSpot")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        self.transition(toRootViewController: vc!, animated: true)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {

    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if UserDefaults.standard.object(forKey: "FirstRun") == nil {
            UserDefaults.standard.set("1stRun", forKey: "FirstRun")
            UserDefaults.standard.synchronize()
            
            RSKeychainHelper.clearKeychain()
        }
        
        
        return true
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("data")
        print(logsPath!)
        do {
            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        self.store = RSStore()
        self.store.setValueInState(value: true as NSSecureCoding, forKey: "shouldDoSpot")
        self.store.set(value: true as NSSecureCoding, key: "shouldDoNotif")
        
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: self.store,
            localizationHelper: nil,
            elementGeneratorServices: AppDelegate.elementGeneratorServices,
            stepGeneratorServices: AppDelegate.stepGeneratorServices,
            answerFormatGeneratorServices: AppDelegate.answerFormatGeneratorServices
        )
        
//        self.ls2Manager = LS2Manager(baseURL: "https://development.ls2.curiosityhealth.com/dsu", queueStorageDirectory: "LS2SDK", store: RSStore())
        self.ls2Manager = self.initializeLS2(credentialStore: RSKeychainCredentialsStore(namespace: "ls2sdk"), config: "development", logger: nil)

        self.ls2Backend = LS2BackEnd(ls2Mananager: self.ls2Manager, transformers: [LS2DefaultTransformer.self])
        self.resultsProcessor = RSRPResultsProcessor(
                frontEndTransformers: AppDelegate.resultsTransformers,
                backEnd: self.ls2Backend
        )
        
//        self.CSVBackend = RSRPCSVBackEnd(outputDirectory: documentsPath as URL)
//        self.resultsProcessor = RSRPResultsProcessor(
//            frontEndTransformers: AppDelegate.resultsTransformers,
//            backEnd: self.CSVBackend
//        )
        
         var resultsTransformers: [RSRPFrontEndTransformer.Type] {
            return [
                YADLFullRaw.self,
                YADLSpotRaw.self,
                CTFPAMRaw.self,
                DemographicsSurveyResult.self,
                CTFBARTSummaryResultsTransformer.self,
                CTFDelayDiscountingRawResultsTransformer.self,
                LS2AutoResult.self
            ]
        }

        
        
        if #available(iOS 10.0, *) {
            // self.center = UNUserNotificationCenter.current()
            self.center.delegate = self
            self.center.requestAuthorization(options: [UNAuthorizationOptions.sound ], completionHandler: { (granted, error) in
                if error == nil{
                    // UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            let settings  = UIUserNotificationSettings(types: [UIUserNotificationType.alert , UIUserNotificationType.badge , UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
        }
        
        // Navigate to correct view controller
        self.showViewController(animated: false)

        
        
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle code here.
        completionHandler([UNNotificationPresentationOptions.sound , UNNotificationPresentationOptions.alert , UNNotificationPresentationOptions.badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.store.setValueInState(value: true as NSSecureCoding, forKey: "shouldDoSpot")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        self.transition(toRootViewController: vc!, animated: true)
        
        
        completionHandler()
    }
    
    open func signOut() {
        
        ls2Manager.signOut(completion:  { (error) in
            if error == nil {
              //  self.store.reset()
                if #available(iOS 10.0, *) {
                    self.center.removeAllDeliveredNotifications()
                    self.center.removeAllPendingNotificationRequests()
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.cancelAllLocalNotifications()
                    
                }
                
                DispatchQueue.main.async {
                    self.showViewController(animated: true)
                }
            }
        
        })
        

    }
    func signedIn () -> Bool {
        let isSignedIn = ls2Manager.isSignedIn
        return isSignedIn
    }
    
    open func showViewController(animated: Bool) {
        
        if(signedIn()){
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateInitialViewController()
            self.transition(toRootViewController: vc!, animated: animated)
        }
        else {
            let storyboard = UIStoryboard(name: "WelcomeStoryboard", bundle: Bundle.main)
            let vc = storyboard.instantiateInitialViewController()
            self.transition(toRootViewController: vc!, animated: animated)
        }
        

        
//        if UserDefaults.standard.bool(forKey: "PassCreated"){
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let vc = storyboard.instantiateInitialViewController()
//            self.transition(toRootViewController: vc!, animated: animated)
//        }
//        else {
//            let storyboard = UIStoryboard(name: "PasscodeStoryboard", bundle: Bundle.main)
//            let vc = storyboard.instantiateInitialViewController()
//            self.transition(toRootViewController: vc!, animated: animated)
//
//        }

        
    }
    
    // Make sure to include all step generators needed for your survey steps here
    open class var stepGeneratorServices: [RSTBStepGenerator] {
        return [
            YADLFullStepGenerator(),
            YADLSpotStepGenerator(),
            PAMStepGenerator(),
            RSTBLocationStepGenerator(),
            RSTBLocationStepGenerator(),
            RSTBInstructionStepGenerator(),
            RSTBTextFieldStepGenerator(),
            RSTBIntegerStepGenerator(),
            RSTBDecimalStepGenerator(),
            RSTBTimePickerStepGenerator(),
            RSTBFormStepGenerator(),
            RSTBDatePickerStepGenerator(),
            RSTBSingleChoiceStepGenerator(),
            RSTBMultipleChoiceStepGenerator(),
            RSTBBooleanStepGenerator(),
            RSTBPasscodeStepGenerator(),
            RSTBScaleStepGenerator(),
            LS2LoginStepGenerator()
        ]
    }
    
    // Make sure to include all step generators needed for your survey steps here also
    open class var answerFormatGeneratorServices:  [RSTBAnswerFormatGenerator] {
        return [
            RSTBLocationStepGenerator(),
            RSTBTextFieldStepGenerator(),
            RSTBSingleChoiceStepGenerator(),
            RSTBIntegerStepGenerator(),
            RSTBDecimalStepGenerator(),
            RSTBTimePickerStepGenerator(),
            RSTBDatePickerStepGenerator(),
            RSTBScaleStepGenerator()
        ]
    }
    
    open class var elementGeneratorServices: [RSTBElementGenerator] {
        return [
            RSTBElementListGenerator(),
            RSTBElementFileGenerator(),
            RSTBElementSelectorGenerator()
        ]
    }
    
    // Make sure to include any result transforms for custom steps here
    open class var resultsTransformers: [RSRPFrontEndTransformer.Type] {
        return [
            YADLFullRaw.self,
            YADLSpotRaw.self,
            CTFPAMRaw.self,
            DemographicsSurveyResult.self,
            CTFBARTSummaryResultsTransformer.self,
            CTFDelayDiscountingRawResultsTransformer.self
        ]
    }
    
    /**
     Convenience method for transitioning to the given view controller as the main window
     rootViewController.
     */
    open func transition(toRootViewController: UIViewController, animated: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
        guard let window = self.window else { return }
        if (animated) {
            let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
            toRootViewController.view.addSubview(snapshot);
            
            self.window?.rootViewController = toRootViewController;
            
            UIView.animate(withDuration: 0.3, animations: {() in
                snapshot.layer.opacity = 0;
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
                completion?(value)
            })
        }
        else {
            window.rootViewController = toRootViewController
            completion?(true)
        }
    }
    
    //utilities
    static func loadSchedule(filename: String) -> RSAFSchedule? {
        guard let json = AppDelegate.getJson(forFilename: filename) as? JSON else {
            return nil
        }
        
        return RSAFSchedule(json: json)
    }
    
    static func configJSONBaseURL() -> String {
        return Bundle.main.resourceURL!.appendingPathComponent("config").absoluteString
    }
    
    static func loadScheduleItem(filename: String) -> RSAFScheduleItem? {
        
        guard let json = AppDelegate.getJSON(fileName: filename, inDirectory: nil, configJSONBaseURL: self.configJSONBaseURL()) else {
            return nil
        }
        
        return RSAFScheduleItem(json: json)
    }
    
    static func loadActivity(filename: String) -> JSON? {
        return AppDelegate.getJSON(fileName: filename, inDirectory: nil, configJSONBaseURL: self.configJSONBaseURL())
    }
    
    static func getJson(forFilename filename: String, inBundle bundle: Bundle = Bundle.main) -> JsonElement? {
        
        guard let filePath = bundle.path(forResource: filename, ofType: "json")
            else {
                assertionFailure("unable to locate file \(filename)")
                return nil
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                assertionFailure("Unable to create NSData with content of file \(filePath)")
                return nil
        }
        
        let json = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return json as JsonElement?
    }
    
    open static func getJSON(fileName: String, inDirectory: String? = nil, configJSONBaseURL: String? = nil) -> JSON? {
        
        let urlPath: String = inDirectory != nil ? inDirectory! + "/" + fileName : fileName
        guard let urlBase = configJSONBaseURL,
            let url = URL(string: urlBase + urlPath) else {
                return nil
        }
        
        return self.getJSON(forURL: url)
    }
    
    open static func getJSON(forURL url: URL) -> JSON? {
        
        print(url)
        guard let fileContent = try? Data(contentsOf: url)
            else {
                assertionFailure("Unable to create NSData with content of file \(url)")
                return nil
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)) as? JSON else {
            return nil
        }
        
        return json
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }
    
    
}

extension RSKeychainCredentialsStore: RSTBStateHelper {
    public func objectInState(forKey: String) -> AnyObject? {
        return nil
    }
    
    public func valueInState(forKey: String) -> NSSecureCoding? {
        return self.get(key: forKey)
    }
    
    public func setValueInState(value: NSSecureCoding?, forKey: String) {
        self.set(value: value, key: forKey)
    }
    
    
}

