//
//  ViewController.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var buttonBack: UIButton!
    @IBOutlet private weak var buttonForward: UIButton!
    @IBOutlet private weak var navBarContainer: UIView!
    
    var pathView: CustomPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaves()
    }
    
    private func setupWaves() {
        pathView = CustomPath(frame: self.view.frame,
                              color: UIColor.blue,
                              delay: 0.0,
                              duration: 1,
                              maxHeight: navBarContainer.frame.height)
        
        pathView.isUserInteractionEnabled = false
       
        navBarContainer.addSubview(pathView)
    }
    
    @IBAction private func buttonStart(_ sender: Any) {
        pathView.animateShape(isForward: true)
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        pathView.animateShape(isForward: false)
    }
    
    @IBAction private func forwardButtonAction(_ sender: UIButton) {
        pathView.animateShape(isForward: true)
    }
}

