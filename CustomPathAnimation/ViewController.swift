//
//  ViewController.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    var pathView: CustomPath!
    var pathViewBack: CustomPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pathViewBack = CustomPath(frame: self.view.frame, color: UIColor.gray)
        let pathViewBack2 = CustomPath(frame: self.view.frame, color: UIColor.red, delay: 0.2)
        pathView = CustomPath(frame: self.view.frame, color: UIColor.blue)
        pathViewBack2.isUserInteractionEnabled = false
        pathViewBack.isUserInteractionEnabled = false
        pathView.isUserInteractionEnabled = false
        view.addSubview(pathViewBack2)
        view.addSubview(pathViewBack)
        view.addSubview(pathView)
        pathViewBack2.animateShape(isForward: false)
        pathViewBack.animateShape(isForward: false)
        pathView.animateShape(isForward: true)
        
        pathViewBack2.animationHandler = { isAnimating in
            if !isAnimating {
                pathViewBack2.removeFromSuperview()
            }
        }
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

