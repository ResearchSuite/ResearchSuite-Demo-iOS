//
//  RSTextInstructionStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/18/18.
//

import UIKit
import SnapKit

open class RSTextInstructionStepViewController: RSQuestionViewController {

    var scrollView: UIScrollView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let step = self.step as? RSTextInstructionStep else {
            return
        }
        
        guard let sections = step.sections else {
            return
        }
        
        let stackedViews: [UIView] = sections.map { section in
            let label = UILabel()
            label.numberOfLines = 0
            label.attributedText = section.attributedText
            label.textAlignment = section.alignment
            label.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            return label
        }
        
        let stackView = UIStackView(arrangedSubviews: stackedViews)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 8.0
        
        let scrollView = UIScrollView()
        scrollView.frame = self.contentView.bounds
        self.contentView.addSubview(scrollView)
        self.scrollView = scrollView
        scrollView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.frame = self.contentView.bounds
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.contentView.bounds
    }
    
}
