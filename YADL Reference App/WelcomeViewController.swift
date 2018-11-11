//
//  PasscodeViewController.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 1/26/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import LS2SDK
import ResearchSuiteAppFramework

class WelcomeViewController: UIViewController {
    
    var signInItem: RSAFScheduleItem!
    var store: RSStore!

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store = RSStore()
        
        let color = UIColor(red: 0.44, green: 0.66, blue: 0.86, alpha: 1.0)
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = color.cgColor
        startButton.layer.cornerRadius = 5
        startButton.clipsToBounds = true
        


        // Do any additional setup after loading the view.
    }
    
    @IBAction func startClicked(_ sender: Any) {
        self.launchLogin()
    }
//    func launchSignin() {
//
//
//        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: Bundle.main)
//        let vc = storyboard.instantiateInitialViewController()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.transition(toRootViewController: vc!, animated: true)
//    }
    
    func launchLogin(){

        guard let signInActivity = AppDelegate.loadScheduleItem(filename: "signin.json"),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: signInActivity.activity as JsonElement) else {
                return
        }

        let task = ORKOrderedTask(identifier: signInActivity.identifier, steps: steps)

        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in

            //when done, tell the app delegate to go back to the correct screen
            self?.dismiss(animated: true, completion: {
                
                if error == nil {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
                        let vc = storyboard.instantiateInitialViewController()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.transition(toRootViewController: vc!, animated: true)
                    }
                }
                else {
                    NSLog(String(describing:error))
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
    
 
    


}
