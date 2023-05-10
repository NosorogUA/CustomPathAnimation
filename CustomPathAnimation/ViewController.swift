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
    var pathView2: CustomPath!
    var pathView3: CustomPath!
    
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
        
        pathView2 = CustomPath(frame: self.view.frame,
                              color: UIColor.gray,
                              delay: 0.2,
                              duration: 1,
                              maxHeight: navBarContainer.frame.height)
        
        pathView2.isUserInteractionEnabled = false
        
        pathView3 = CustomPath(frame: self.view.frame,
                              color: UIColor.green,
                              delay: 0.4,
                              duration: 1,
                              maxHeight: navBarContainer.frame.height)
        
        pathView3.isUserInteractionEnabled = false
        
        pathView3.animationHandler = { [weak self] isAnimating in
            if !isAnimating {
                self?.pathView3.removeFromSuperview()
            }
        }
       
        navBarContainer.addSubview(pathView3)
        navBarContainer.addSubview(pathView2)
        navBarContainer.addSubview(pathView)
    }
    
    @IBAction private func buttonStart(_ sender: Any) {
        pathView.animateShape(isForward: true)
        pathView2.animateShape(isForward: false)
        pathView3.animateShape(isForward: true)
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        pathView.animateShape(isForward: false)
        pathView2.animateShape(isForward: true)
    }
    
    @IBAction private func forwardButtonAction(_ sender: UIButton) {
        pathView.animateShape(isForward: true)
        pathView2.animateShape(isForward: false)
    }
}

