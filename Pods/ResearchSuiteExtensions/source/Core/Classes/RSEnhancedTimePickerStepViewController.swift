//
//  RSEnhancedTimePickerStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/19/18.
//

import UIKit
import ResearchKit

open class RSEnhancedTimePickerStepViewController: RSQuestionViewController {

    static func getDateForComponents(timeOfDayComponents: DateComponents, date: Date = Date()) -> Date? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return calendar.date(byAdding: timeOfDayComponents, to: startOfDay)
    }
    
    static func getTimeOfDayComponentsFromDate(date: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: date)
    }
    
    var datePicker: UIDatePicker?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let timePickerStep = self.step as? RSEnhancedTimePickerStep else {
            return
        }
        
        let datePicker = UIDatePicker()
        self.datePicker = datePicker
        datePicker.datePickerMode = .time
        
        let dateForComponents: (DateComponents?) -> Date? = { components in
            if let components = components {
                return RSEnhancedTimePickerStepViewController.getDateForComponents(timeOfDayComponents: components)
            }
            else {
                return nil
            }
        }
        
        datePicker.minuteInterval = timePickerStep.minuteInterval ?? 1
        
        datePicker.maximumDate = dateForComponents(timePickerStep.maximumComponents)
        datePicker.minimumDate = dateForComponents(timePickerStep.minimumComponents)
        
        let initialDate: Date = {
            let date = dateForComponents(timePickerStep.defaultComponents) ?? Date()
            if let minDate = datePicker.minimumDate,
                date < minDate {
                return minDate
            }
            else if let maxDate = datePicker.maximumDate,
                date > maxDate {
                return maxDate
            }
            else {
                return date
            }
        }()
        
        let roundedDate: Date? = {
            let calendar = Calendar.current
            var timeOfDayComponents = calendar.dateComponents([.hour, .minute], from: initialDate)
            let minute = timeOfDayComponents.minute!
            
            //round down
            timeOfDayComponents.minute = (minute / datePicker.minuteInterval) * datePicker.minuteInterval
            return RSEnhancedTimePickerStepViewController.getDateForComponents(timeOfDayComponents: timeOfDayComponents)
        }()
        
        if let roundedDate = roundedDate {
            datePicker.setDate(roundedDate, animated: false)
        }
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.frame = self.contentView.bounds
        self.contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(UIView())
        
    }
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        
        if self.hasAppeared,
            let step = self.step,
            let pickerDate = self.datePicker?.date {
            
            let components = RSEnhancedTimePickerStepViewController.getTimeOfDayComponentsFromDate(date: pickerDate)
            let timeOfDayResult = ORKTimeOfDayQuestionResult(identifier: step.identifier)
            timeOfDayResult.dateComponentsAnswer = components
            timeOfDayResult.startDate = parentResult.startDate
            timeOfDayResult.endDate = parentResult.endDate
            
            parentResult.results = [timeOfDayResult]
        }
        
        return parentResult
    }
}
