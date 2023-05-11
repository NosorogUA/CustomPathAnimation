//
//  CustomPath.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

class CustomPath: UIView {
    
    private let stateMachine: WaveStateMachine
    
    private let shapeLayer = CAShapeLayer()
    
    private let color: UIColor
    private let mainDuration: TimeInterval = 0.4
    private let duration: TimeInterval
    private let delay: TimeInterval
   
    var animationHandler: ((Bool) -> Void)?
    
    init(frame: CGRect, color: UIColor, delay: TimeInterval = 0.0, duration: TimeInterval = 1.5, maxHeight: CGFloat = 100) {
        self.color = color
        self.delay = delay
        self.duration = duration
        stateMachine = WaveStateMachine(currentFrame: frame, maxWaveY: maxHeight)
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Wave view deinit")
    }
    
    private func setup() {
        self.shapeLayer.path = stateMachine.setupStartPath().cgPath
        shapeLayer.fillColor = color.cgColor
        self.layer.addSublayer(self.shapeLayer)
    }
    
    func changeShape() {
        self.shapeLayer.path = stateMachine.setupStartPath().cgPath
        animationHandler?(false)
    }
    
    func animateShape(isForward: Bool) {
        animationHandler?(true)
        
        var animationDuration: TimeInterval = mainDuration
        var animationDelay: TimeInterval = 0.0
        dump(stateMachine)
        switch stateMachine.currentState {
        case .splash:
            animationDuration = duration
            animationDelay = delay
        case .start, .finish:
            break
        }
        
        let new: UIBezierPath = stateMachine.initStartShape(isDirectionForward: isForward)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self else { return }
            self.shapeLayer.path = new.cgPath
            self.finishAnimation()
        }
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.beginTime = CACurrentMediaTime() + animationDelay
        animation.duration = animationDuration
        animation.toValue = new.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        self.shapeLayer.add(animation, forKey: "waves")
        
        CATransaction.commit()
    }
    
    private func finishAnimation() {
        let new: UIBezierPath = stateMachine.initTransitionPath()

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = mainDuration
        animation.toValue = new.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.delegate = self
        
        self.shapeLayer.add(animation, forKey: "waves")
    }
}

extension CustomPath: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.changeShape()
        }
    }
}
