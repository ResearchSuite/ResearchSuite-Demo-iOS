//
//  RSEnhancedInstructionStepViewController.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit

open class RSEnhancedInstructionStepViewController: RSQuestionViewController {

    var stackView: UIStackView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let step = self.step as? RSEnhancedInstructionStep else {
            return
        }
        
        var stackedViews: [UIView] = []

        if let gifURL = step.gifURL {
            
            let imageView = UIImageView()
            imageView.setGifFromURL(gifURL)
            
            stackedViews.append(imageView)
            
        }
        
        let stackView = UIStackView(arrangedSubviews: stackedViews)
        stackView.frame = self.contentView.bounds
        self.stackView = stackView
        
        self.contentView.addSubview(stackView)
    }

}
