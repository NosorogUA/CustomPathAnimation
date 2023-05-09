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
    
    var pathView: CustomPath!
    var pathViewBack: CustomPath!
    var pathViewBack2: CustomPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaves()
    }
    
    private func setupWaves() {
        pathView = CustomPath(frame: self.view.frame, color: UIColor.blue)
        pathView.isUserInteractionEnabled = false
        
        pathViewBack = CustomPath(frame: self.view.frame, color: UIColor.gray)
        pathViewBack.isUserInteractionEnabled = false
        
        pathViewBack.animationHandler = { [weak self] isAnimating in
            self?.buttonBack.isEnabled = !isAnimating
            self?.buttonForward.isEnabled = !isAnimating
        }
        
        pathViewBack2 = CustomPath(frame: self.view.frame, color: UIColor.red, delay: 0.5)
        pathViewBack2.isUserInteractionEnabled = false
        
        pathViewBack2.animationHandler = { [weak self] isAnimating in
            if !isAnimating {
                self?.pathViewBack2.removeFromSuperview()
            }
        }
        
        view.addSubview(pathViewBack2)
        view.addSubview(pathViewBack)
        view.addSubview(pathView)
        
        pathViewBack2.animateShape(isForward: true)
        pathViewBack.animateShape(isForward: false)
        pathView.animateShape(isForward: true)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        pathViewBack.animateShape(isForward: true)
        pathView.animateShape(isForward: false)
    }
    
    @IBAction func forwardButtonAction(_ sender: UIButton) {
        pathViewBack.animateShape(isForward: false)
        pathView.animateShape(isForward: true)
    }
}

