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
    var pathViewBack: CustomPath!
    var pathViewBack2: CustomPath!

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
        
        pathViewBack = CustomPath(frame: self.view.frame,
                                  color: UIColor.gray,
                                  delay: 0.2,
                                  duration: 1,
                                  maxHeight: navBarContainer.frame.height)
        pathViewBack.isUserInteractionEnabled = false

        pathViewBack.animationHandler = { [weak self] isAnimating in
            self?.buttonBack.isEnabled = !isAnimating
            self?.buttonForward.isEnabled = !isAnimating
        }
        
        pathViewBack2 = CustomPath(frame: self.view.frame,
                                   color: UIColor.red,
                                   delay: 0.4,
                                   duration: 1,
                                   maxHeight: navBarContainer.frame.height)
        
        pathViewBack2.isUserInteractionEnabled = false

        pathViewBack2.animationHandler = { [weak self] isAnimating in
            if !isAnimating {
                self?.pathViewBack2.removeFromSuperview()
            }
        }
        
        navBarContainer.addSubview(pathViewBack2)
        navBarContainer.addSubview(pathViewBack)
        navBarContainer.addSubview(pathView)
    }
    
    @IBAction private func puttonStart(_ sender: Any) {
        pathViewBack2.animateShape(isForward: true)
        pathViewBack.animateShape(isForward: false)
        pathView.animateShape(isForward: true)
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        pathViewBack.animateShape(isForward: true)
        pathView.animateShape(isForward: false)
    }
    
    @IBAction private func forwardButtonAction(_ sender: UIButton) {
        pathViewBack.animateShape(isForward: false)
        pathView.animateShape(isForward: true)
    }
}

