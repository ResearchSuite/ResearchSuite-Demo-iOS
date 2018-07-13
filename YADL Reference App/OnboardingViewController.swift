//
//  YADLOnboardingViewController.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 11/6/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import UserNotifications
import ResearchSuiteAppFramework


class OnboardingViewController: UIViewController {
    
    let kActivityIdentifiers = "activity_identifiers"
    

    var store: RSStore!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var notifItem: RSAFScheduleItem!
    var fullAssessmentItem: RSAFScheduleItem!
    var spotAssessmentItem: RSAFScheduleItem!
    var pamAssessmentItem: RSAFScheduleItem!
    var demographicsAssessmentItem: RSAFScheduleItem!
    var locationAssessmentItem: RSAFScheduleItem!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.store = RSStore()
//
//        let color = UIColor.init(colorLiteralRed: 0.44, green: 0.66, blue: 0.86, alpha: 1.0)
//        startButton.layer.borderWidth = 1.0
//        startButton.layer.borderColor = color.cgColor
//        startButton.layer.cornerRadius = 5
//        startButton.clipsToBounds = true
//
 
    }

    override func viewDidAppear(_ animated: Bool) {
        
       // self.launchLogin()
        
//        self.notifItem = AppDelegate.loadScheduleItem(filename: "notification")
//        self.launchActivity(forItem: (self.notifItem)!)
        let shouldSetNotif = self.store.valueInState(forKey: "shouldDoNotif") as! Bool
        
        if(shouldSetNotif){
            self.notifItem = AppDelegate.loadScheduleItem(filename: "notification.json")
            self.launchActivity(forItem: (self.notifItem)!)
        }
        
        
    }
    
//    func launchLogin(){
//
//        guard let signInActivity = AppDelegate.loadActivity(filename: "signin"),
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//            let steps = appDelegate.taskBuilder.steps(forElement: signInActivity as JsonElement) else {
//                return
//        }
//
//        let task = ORKOrderedTask(identifier: "signin", steps: steps)
//
//        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
//
//            //when done, tell the app delegate to go back to the correct screen
//            self?.dismiss(animated: true, completion: {
//            })
//
//        }
//
//        let tvc = RSAFTaskViewController(
//            activityUUID: UUID(),
//            task: task,
//            taskFinishedHandler: taskFinishedHandler
//        )
//
//        self.present(tvc, animated: true, completion: nil)
//
//    }
    
    func launchActivity(forItem item: RSAFScheduleItem) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: item.activity as JsonElement) else {
                return
        }
        
        let task = ORKOrderedTask(identifier: item.identifier, steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            //when finised, if task was successful (e.g., wasn't canceled)
            //process results
            if reason == ORKTaskViewControllerFinishReason.completed {
                let taskResult = taskViewController.result
                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
                
                if(item.identifier == "notification_date"){
                    
                    let result = taskResult.stepResult(forStepIdentifier: "notification_time_picker")
                    let timeAnswer = result?.firstResult as? ORKTimeOfDayQuestionResult
                    
                    let resultAnswer = timeAnswer?.dateComponentsAnswer
                    self?.setNotification(resultAnswer: resultAnswer!)
                    
                    self?.store.set(value: false as NSSecureCoding, key: "shouldDoNotif")
                    
                }
                
                if(item.identifier == "yadl_spot") {
                    self?.store.setValueInState(value: true as NSSecureCoding, forKey: "spotFileExists")
                    self?.store.set(value: true as NSSecureCoding, key: "signedIn")
                }
                
                if(item.identifier == "yadl_full"){
                    
                    // save date that full assessment was completed
                    
                    let date = Date()
                    
                    self?.store.setValueInState(value: date as NSSecureCoding, forKey: "dateFull")
                    
                    self?.store.setValueInState(value: true as NSSecureCoding, forKey: "fullFileExists")
                    
                    // save for spot assessment
                    
                    if let difficultActivities: [String]? = taskResult.results?.flatMap({ (stepResult) in
                        if let stepResult = stepResult as? ORKStepResult,
                            stepResult.identifier.hasPrefix("yadl_full."),
                            let choiceResult = stepResult.firstResult as? ORKChoiceQuestionResult,
                            let answer = choiceResult.choiceAnswers?.first as? String,
                            answer == "hard" || answer == "moderate"
                        {
                            var tempResult = stepResult.identifier
                            let index = tempResult.index(tempResult.startIndex, offsetBy: 10)
                            tempResult = tempResult.substring(from:index)
                            
                            
                            NSLog(tempResult)
                            
                            return tempResult.replacingOccurrences(of: "yadl_full.", with: "")
                            
                        }
                        return nil
                    }) {
                        if let answers = difficultActivities {
                            
                            
                            self?.store.setValueInState(value: answers as NSSecureCoding, forKey: "activity_identifiers")
                            
                            
                            
                            NSLog("answers")
                            NSLog(String(describing:answers))
                            
                            // save when completed full assessment
                            
                            
                        }
                    }
                    
                    
                    
                }
                
            }
            
            self?.dismiss(animated: true, completion: {
                
                if(item.identifier == "notification_date"){
                    self!.fullAssessmentItem = AppDelegate.loadScheduleItem(filename:"yadl_full.json")
                    self?.launchActivity(forItem: (self?.fullAssessmentItem)!)
                    
                }

                if(item.identifier == "yadl_full"){
                    self!.spotAssessmentItem = AppDelegate.loadScheduleItem(filename:"yadl_spot.json")
                    self?.launchActivity(forItem: (self?.spotAssessmentItem)!)
                }

                if(item.identifier == "yadl_spot"){
                    self?.store.setValueInState(value: false as NSSecureCoding, forKey: "shouldDoSpot")
                    self!.pamAssessmentItem = AppDelegate.loadScheduleItem(filename: "pam.json")
                    self?.launchActivity(forItem: (self?.pamAssessmentItem)!)
                }
                if(item.identifier == "PAM"){
                    self!.demographicsAssessmentItem = AppDelegate.loadScheduleItem(filename:"demographics.json")
                    self?.launchActivity(forItem: (self?.demographicsAssessmentItem)!)
                }
                if(item.identifier == "demographics"){
                    self!.locationAssessmentItem = AppDelegate.loadScheduleItem(filename: "LocationSurvey.json")
                    self?.launchActivity(forItem: (self?.locationAssessmentItem)!)
                    
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = storyboard.instantiateInitialViewController()
                    appDelegate.transition(toRootViewController: vc!, animated: true)
                }
                
                

                
            })
            
            
            
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
        
    }
    
    func setNotification(resultAnswer: DateComponents) {
        
        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone(abbreviation: "EDT")!
        
        var fireDate = NSDateComponents()
        
        let hour = resultAnswer.hour
        let minutes = resultAnswer.minute
        
        fireDate.hour = hour!
        fireDate.minute = minutes!
        
        self.store.setValueInState(value: String(describing:hour!) as NSSecureCoding, forKey: "notificationHour")
        self.store.setValueInState(value: String(describing:minutes!) as NSSecureCoding, forKey: "notificationMinutes")
        
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "ResearchSuite"
            content.body = "It'm time to complete your ResearchSuite Spot Assessments"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate as DateComponents,
                                                        repeats: true)
            
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                }
            })
            
        } else {
            // Fallback on earlier versions
            
            let dateToday = Date()
            let day = userCalendar.component(.day, from: dateToday)
            let month = userCalendar.component(.month, from: dateToday)
            let year = userCalendar.component(.year, from: dateToday)
            
            fireDate.day = day
            fireDate.month = month
            fireDate.year = year
            
            let fireDateLocal = userCalendar.date(from:fireDate as DateComponents)
            
            let localNotification = UILocalNotification()
            localNotification.fireDate = fireDateLocal
            localNotification.alertTitle = "ResearchSuite"
            localNotification.alertBody = "It's time to complete your ResearchSuite Spot Assessments"
            localNotification.timeZone = TimeZone(abbreviation: "EDT")!
            //set the notification
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
        
        
    }


    
    
    

}
