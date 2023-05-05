//
//  ViewController.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    var pathView: CustomPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pathView = CustomPath(frame: self.view.frame)
        pathView.isUserInteractionEnabled = false
        view.addSubview(pathView)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        pathView.animateShape(isForward: false)
    }
    
    @IBAction func forwardButtonAction(_ sender: UIButton) {
        pathView.animateShape(isForward: true)
    }
}

