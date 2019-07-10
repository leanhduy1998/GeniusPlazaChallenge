//
//  ViewController.swift
//  GeniusPlazaCodingChallenge
//
//  Created by Duy Le 2 on 7/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    fileprivate let segmentedControl = UISegmentedControl(items: ["Music","Book"])
    
    private var topPadding:CGFloat = 0
    private var bottomPadding:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        addSegmentedControl()
    }
    
    private func addSegmentedControl(){
        view.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
        view.backgroundColor = UIColor.white
    }
    
    @objc private func segmentedControlValueChanged(){
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getSafePadding()
        setupSegmentControlPosition()
    }
    
    private func setupSegmentControlPosition(){
        let spacing:CGFloat = 10
        segmentedControl.frame = CGRect(x: spacing, y: topPadding + spacing, width: view.frame.width - spacing*2, height: 30)
    }
    
    private func getSafePadding(){
        let window = UIApplication.shared.keyWindow
        guard let topPadding = window?.safeAreaInsets.top else{return}
        guard let bottomPadding = window?.safeAreaInsets.bottom else{return}
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
    }


}

